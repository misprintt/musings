package musings;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import haxe.macro.Expr;
import haxe.macro.Type;
import test.TestClasses;

using musings.Tools;

class ComplexTypesTest
{
	public function new()
	{

	}


	@Test
	public function shouldConvertToExpr()
	{
		var expected = {pack:[], name:"A", sub:null, params:[]};
		var actual = switch("A".toComplexType())
		{
			case TPath(tp): tp;
			case _: null;
		}

		assertTypePathsEqual(expected, expected);

		expected = {pack:["a","b"], name:"C", sub:"D", params:[]};
		actual = switch("a.b.C.D".toComplexType())
		{
			case TPath(tp): tp;
			case _: null;
		}
		assertTypePathsEqual(expected, expected);
	}


	function assertTypePathsEqual(expected:TypePath,actual:TypePath, ?pos:haxe.PosInfos)
	{
		Assert.isNotNull(expected, pos);
		Assert.isNotNull(actual, pos);
		Assert.areEqual(expected.pack.length, actual.pack.length, pos);
		Assert.areEqual(expected.name, actual.name, pos);
		Assert.areEqual(expected.sub, actual.sub, pos);
		Assert.areEqual(expected.params.length, actual.params.length, pos);
	}

	@Test
	public function shouldConvertToString()
	{
		var c = "a.b.C.D".toComplexType();
		Assert.areEqual("a.b.C.D", c.toString());
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
			var complexType = ident.toComplexType();
			var type = complexType.toType();

			return type.toString().toConstant().at();
		}
		catch(e:Dynamic)
		{
			return Std.string(e).toConstant().at();
		}
	}

}
