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
	#if (haxe_ver < 3.1)
	/**
	Generates a ComplexType from a qualified path
	*/
	inline static public function toComplex(ident:String):ComplexType
	{
		return TPath(ident.toTypePath());
	}
	#end


	#if macro

	/**
		Returns the default 'null' value for a type.

		On static platforms (Flash, CPP, Java, C#), basic types have their own default values :

		every Int is by default initialized to 0
		every Float is by default initialized to NaN on Flash9+, and to 0.0 on CPP, Java and C#
		every Bool is by default initialized to false
	*/
	static public function getDefaultValue(type:ComplexType):Expr
	{
		if(Tools.isStaticPlatform())
		{
			switch(type)
			{
				case TPath(p):
				{
					if(p.pack.length != 0) return EConst(CIdent("null")).at();

					if(p.name == "StdTypes") p.name = p.sub;

					switch(p.name)
					{
						case "Bool":
							return EConst(CIdent("false")).at();
						case "Int":
							return EConst(CInt("0")).at();
						case "Float":
							if( Context.defined("flash"))
								return "Math.NaN".toFieldExpr();
							else
								return EConst(CFloat("0.0")).at();
						default: null;
					}	
				}
				default: null;
			}
		}
		return EConst(CIdent("null")).at();
	}
	#end
}