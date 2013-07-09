package musings;

import sys.io.File;
import sys.FileSystem;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Context;
import haxe.macro.Compiler;

using musings.Tools;

/**
	This class provides some utility methods to work with Field instances. It is
	best used through 'using musings.Fields' syntax and then provides
	additional methods on haxe.macro.Field instances.
**/
class Fields
{
	/**
	Returns the Expr value within an field [f].
	*/
	inline static public function getExpr(f:Field):Expr
	{
		return switch(f.kind)
		{
			case FVar(_,e): e;
			case FProp(_,_,_, e): e;
			case FFun(f): f.expr;
		}
	}

	/**
	Returns the complex type defined within field [f].

	If [f] is a function then the return type is returned
	*/
	inline static public function getComplexType(f:Field):ComplexType
	{
		return switch(f.kind)
		{
			case FVar(t,_): t;
			case FProp(_,_,t,_): t;
			case FFun(f): f.ret;
		}
	}

	/**
	Returns a new field instance populated with [name] and [kind]
	
	If [kind] is null then an kind is set to empty FVar
	*/
	static public function toField(name:String, ?kind:FieldType, ?pos:Position):Field
	{
		return 
		{
			name: 	name,
			pos: 	pos.getPos(),
			kind: 	kind != null ? kind : FVar(null,null),
		};
	}


	/**
	Returns a copy of field [f].
	*/
	static public function clone(f:Field):Field
	{
		return
		{
			pos: 		f.pos,
			name: 		f.name,
			meta: 		f.meta != null ? f.meta.concat([]) : null,
			kind: 		f.kind,
			doc: 		f.doc,
			access: 	f.access != null ? f.access.concat([]) : null
		}
	}

	/**
	Returns a string representation of the field [f] using haxe.macro.Printer
	*/
	inline static public function toString(f:Field):String
	{
		return Tools.printer.printField(f);
	}

}
