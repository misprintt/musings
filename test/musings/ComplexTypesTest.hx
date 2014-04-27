package musings;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import haxe.macro.Expr;
import haxe.macro.Type;
import test.TestClasses;

using haxe.macro.MacroStringTools;
using musings.Tools;

class ComplexTypesTest
{
	public function new()
	{

	}

	@Test
	public function shouldConvertToString()
	{
		var complex = TPath({pack:["a","b"], name:"C", sub:"D", params:[]});

		Assert.areEqual("a.b.C.D", complex.toString());
	}

	@Test
	public function shouldConvertToType()
	{
		Assert.areEqual("test.SomeClass", macro_toType(test.SomeClass));
	}

	macro static function macro_toType(e:Expr):Expr
	{
		try
		{
			var ident = e.toString();
			var complexType = ident.toComplex();
			var type = complexType.toType();

			return type.toString().toConstant().at();
		}
		catch(e:Dynamic)
		{
			return Std.string(e).toConstant().at();
		}
	}


	@Test
	public function should_return_default_type()
	{
		Assert.areEqual(null, macro_defaultType(String));

		#if (flash || cpp || java || cs)
		Assert.areEqual(false, macro_defaultType(Bool));
		Assert.areEqual(0, macro_defaultType(Int));
		#if flash
			Assert.areEqual(Math.NaN, macro_defaultType(Float));
		#else
			Assert.areEqual(0.0, macro_defaultType(Float));
		#end
		
		#else
		Assert.areEqual(null, macro_defaultType(Bool));
		Assert.areEqual(null, macro_defaultType(Int));
		Assert.areEqual(null, macro_defaultType(Float));
		#end
	}

	macro static function macro_defaultType(expr:Expr):Expr
	{
		try
		{
			var ident = expr.toString();
			var complexType = ident.toComplex();

			return complexType.getDefaultValue();
		}
		catch(e:Dynamic)
		{
			return Std.string(e).toConstant().at();
		}
	}


}
