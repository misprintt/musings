package musings;

import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Context;
import haxe.macro.Compiler;

using musings.Tools;


/**
	This class provides additional utility methods for working with Exprs in 
	combination with haxe.macro.Tools

	best used through 'using musings.Tools' syntax and then provides
	additional methods on haxe.macro.Expr.Expr instances.
**/
class Exprs
{
	/**
		Converts an ExprDef [e] (and optional Position [pos]) into an Expr
	*/
	inline static public function toExpr(e:ExprDef, ?pos:Position):Expr
	{
		return {expr:e, pos:pos.getPos()};
	}

	/**
		Shorthand to convert an ExprDef [e] into an Expr
	*/
	inline static public function at(e:ExprDef, ?pos:Position):Expr
	{
		return e.toExpr(pos);
	}

	/**
		Backwards safe wrapper for converting to a TypedExpr (requires haxe 3.1)
	**/
	static public function toTypedExpr(expr:Expr):Expr
	{
		#if (haxe_ver >= 3.1)
		try
		{
			var typeExpr = Context.typeExpr(expr);
			expr = Context.getTypedExpr(typeExpr);
		}
		catch(e:Dynamic)
		{
			//possibly a typedef structure (cannot)
		}
		#end
		return expr;
	}

	// --------------- expr manipulation

	/**
		Shorthand to create a reference to a EField
	**/
	static public inline function makeField(expr:Expr, field:String, ?pos:Position)
	{
		return EField(expr, field).at(pos);
	}

	/**
		Shorthand for creation an ECall
	**/
	static public inline function makeCall(expr:Expr, ?params:Array<Expr>, ?pos:Position) 
	{
		return ECall(expr, params == null ? [] : params).at(pos);
	}
	
	/**
		Shorthand for converting an array of expressions ot an EArrayDecl
	**/
	static public inline function makeArray(exprs:Array<Expr>, ?pos:Position)
	{
		return EArrayDecl(exprs).at(pos);
	} 

	#if macro

	/**
		Converts a qualified path into a EField reference using `haxe.macro.ExprTools.toFieldExpr'
	
		@see haxe.macro.ExprTools.toFieldExpr
	*/
	inline static public function toFieldExpr(ident:String,?pos:Position):Expr
	{		
		return haxe.macro.MacroStringTools.toFieldExpr(ident.split("."));
	}

	
	/**
		Replaces unqualified type references within expr [e] with fully qualified ones 
	*/
	static public function qualify(e:Expr):Expr
	{
		return qualifyExpr(e);
	}

	static function qualifyExpr(e:Expr):Expr
	{
		return switch(e.expr)
		{
			case ENew(tp,params):
				ENew(tp.qualify(), params.map(qualifyExpr)).at(e.pos);
			case EField(e1,field):
				switch(e1.expr)
				{
					case EField(_,_):
						EField(e1.qualify(), field);
					case _: e;
				}
				e;
			case EConst(CIdent(v)):
				try
				{
					var tp = v.toTypePath();
					tp.qualify().toString().toFieldExpr();

				}
				catch(error:Dynamic)
				{
					trace(e.toString() + ":" + Std.string(error));
					e;
				}
			case _:
				e.map(qualifyExpr);
		}
	}
	
	/**
		Reduces the contents of an expression to a constant value (if possible).
		Supports constants, basic binops and mapped idents
	*/
	static var reduceMap:Map<String,Expr> = null;

	static public function reduce(e:Expr, ?map:Map<String,Expr>):Expr
	{
		if(map == null) map = new Map<String,Expr>();
		reduceMap = map;
		e = reduceExpr(e);
		reduceMap = null;
		return e;
	}

	static function reduceExpr(e:Expr):Expr
	{
		return switch(e.expr)
		{
			case EConst(CIdent(v)):
				if(reduceMap.exists(v))
					reduceMap.get(v).map(reduceExpr);
				else
					return e;
			case EBinop(op,e1,e2):
				reduceBinop(op,e1.map(reduceExpr),e2.map(reduceExpr)).at(e.pos);
			case ENew(t,params):
				ENew(t,params.map(reduceExpr)).at(e.pos);
			case _:
				e.map(reduceExpr);
		}
	}

	#end

	/**
		Tries to calculate the binop value.
		If a value is not a Int, Float or String then defaults
		back to original binop
	*/
	static function reduceBinop(op:Binop, e1:Expr, e2:Expr):ExprDef
	{
		var c1 = e1.getConstant();
		var c2 = e2.getConstant();

		if(c1 == null || c2 == null)
			return EBinop(op, e1, e2);

		var v1 = c1.toValue();
		var v2 = c2.toValue();

		if(v1 == null || v2 == null)
			return EBinop(op, e1, e2);


		var raw = calculateBinop(op, v1, v2);

		if(raw == null)
			return EBinop(op, e1, e2);

		if(c1.isNumber() && c2.isNumber())
		{
			if(c1.isFloat() || c2.isFloat())
			{
				return EConst(CFloat(Std.string(raw)));
			}
			else
			{
				raw = Math.round(raw);
				return EConst(CInt(Std.string(raw)));
			}
		}
		else if(c1.isString() && c2.isString())
		{
			return EConst(CString(Std.string(raw)));
		}
		return return EBinop(op, e1, e2);

	}

	static function calculateBinop(op:Binop, v1:Dynamic, v2:Dynamic):Dynamic
	{
		switch(op)
		{
			case OpMult: return v1 * v2;
			case OpDiv: return v1 / v2;
			case OpAdd: return v1 + v2;
			case OpSub: return v1 - v2;

			case OpAssignOp(op2):
			{
				return calculateBinop(op2, v1, v2);
			}

			default: //trace("unsupported op " + op);
		}

		return null;
	}
}
