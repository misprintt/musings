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
	static public function toComplexType(ident:String):ComplexType
	{
		return TPath(ident.toTypePath());
	}
}