package musings;

import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Context;
import haxe.macro.Compiler;

using musings.Tools;

/**
	This class provides some utility methods to work with Type instances. It is
	best used through 'using musings.Types' syntax and then provides
	additional methods on haxe.macro.Type instances.
**/
class Types
{

	#if macro

	inline static public function toType(ident:String):Type
	{
		return Context.getType(ident);
	}


	static public function getId(t:Type, ?reduced = false)
	{
		if (reduced)
			t = t.follow();
		return
			switch (t) {
				case TAbstract(t, _): t.toString();
				case TInst(t, _): t.toString();
				case TEnum(t, _): t.toString();
				case TType(t, _): t.toString();
				default: null;
			}
	}

	/**
	Wrapper for haxe.macro.TypeTools.toString

	@see haxe.macro.TypeTools.toString
	*/
	inline static public function toString(t:Type):String
	{
		return haxe.macro.TypeTools.toString(t);
	}

	/**
	Wrapper for haxe.macro.TypeTools.getClass

	@see haxe.macro.TypeTools.getClass
	*/
	inline static public function getClassType(type:Type):ClassType
	{
		return haxe.macro.TypeTools.getClass(type);
	}

	/**
	Extracts an array of param types from a TInst type
	*/
	static public function getParams(type:Type):Array<Type>
	{
		switch(type)
		{
			case TInst(t,params): return params;
			case _: throw "Unsupported type [" + Std.string(type) + "]";
		}
	}

	/**
	Wrapper for haxe.macro.TypeTools.toComplexType

	@see haxe.macro.TypeTools.toComplexType
	*/
	inline static public function toComplexType(type:Type):ComplexType
	{
		return haxe.macro.TypeTools.toComplexType(type);
	}
	
	/**
	Converts a Type to a TypeParam
	*/
	public static function toTypeParam(type:Type):TypeParam
	{
		
		switch (type)
		{
			case TInst(t, params): return TPType(toComplexType(type));
			case _: throw "Unsupported type [" + Std.string(type) + "]";
		}
	}

	#end
}
