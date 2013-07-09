package musings;

import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Context;
import haxe.macro.Compiler;

using musings.Tools;

/**
	This class provides some utility methods to work with ComplexType instances. It is
	best used through 'using musings.ComplexTypes' syntax and then provides
	additional methods on haxe.macro.Expr.ComplexType values.
**/
class ComplexTypes
{
	/**
	Generates a ComplexType from a qualified path
	*/
	inline static public function toComplexType(ident:String):ComplexType
	{
		return TPath(ident.toTypePath());
	}

	#if include_std_aliases
	/**
	Alias for haxe.macro.ComplexTypeTools.toString

	@see haxe.macro.ComplexTypeTools.toString
	*/
	inline static public function toString(c:ComplexType):String
	{
		return haxe.macro.ComplexTypeTools.toString(c);
	}


	#if macro
	/**
	Alias for haxe.macro.ComplexTypeTools.toType

	@see haxe.macro.ComplexTypeTools.toType
	*/
	inline static public function toType(c:ComplexType):Null<Type>
	{
		return haxe.macro.ComplexTypeTools.toType(c);
	}

	#end

	#end
}