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
	Shorthand to convert an ExprDef into an Expr
	*/
	inline static public function at(e:ExprDef, ?pos:Position):Expr
	{
		return e.toExpr(pos);
	}

	/**
	Converts a qualified path into a EField reference using `haxe.macro.ExprTools.toFieldExpr'
	
	@see haxe.macro.ExprTools.toFieldExpr
	*/
	inline static public function toFieldExpr(ident:String,?pos:Position):Expr
	{
		return ident.split(".").toFieldExpr();
	}

	#if macro
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
	Tries to calculate the binop value. If a value is not a Int, Float or String then defaults
	back to original binop
	*/
	static function reduceBinop(op:Binop, e1:Expr, e2:Expr):ExprDef
	{
		var c1 = e1.getConstant();
		var c2 = e2.getConstant();

		if(c1 == null || c2 == null)
			return EBinop(op, e1, e2);

		var v1 = c1.resolve();
		var v2 = c2.resolve();

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


	#if include_std_aliases
	/**
	Alias for haxe.macro.ExprTools.toString

	@see haxe.macro.ExprTools.toString
	*/
	inline static public function toString(e:Expr):String
	{
		return haxe.macro.ExprTools.toString(e);
	}

	/**
	Alias for haxe.macro.ExprTools.iter

	@see haxe.macro.ExprTools.iter
	*/
	inline static public function iter( e : Expr, f : Expr -> Void ) : Void
	{
		return haxe.macro.ExprTools.iter(e,f);
	}

	/**
	Alias for haxe.macro.ExprTools.map

	@see haxe.macro.ExprTools.map
	*/
	inline static public function map( e : Expr, f : Expr -> Expr ) : Expr
	{
		return haxe.macro.ExprTools.map(e,f);
	}

	#end
	
}
