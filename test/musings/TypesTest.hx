package musings;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import haxe.macro.Expr;
import haxe.macro.Type;
import test.TestClasses;

using musings.Tools;

class TypesTest
{
	public function new()
	{

	}

	@Test
	public function shouldConvertToType()
	{
		Assert.areEqual("test.SomeClass", macro_toType("SomeClass"));
		Assert.areEqual("test.SomeClass", macro_toType("test.SomeClass"));
		Assert.areEqual("test.SomeAlias", macro_toType("SomeAlias"));
	}

	macro static function macro_toType(e:Expr):Expr
	{
		try
		{
			var id = e.getConstant().parseString();
			var type = id.toType();

			return CString(type.toString()).at(); 
		}
		catch(e:Dynamic)
		{
			return CString(Std.string(e)).at();
		}
	}

	@Test
	public function shouldGetId()
	{
		Assert.areEqual("test.SomeClass", macro_getId(SomeClass));
		Assert.areEqual("test.SomeAlias", macro_getId(SomeAlias));
		Assert.areEqual("test.SomeClass", macro_getId(SomeAlias, true));
	}

	macro static function macro_getId(e:Expr, ?reduceExpr:ExprOf<Bool>):Expr
	{
		try
		{
			var id = e.toString();
			var type = id.toType();

			var const = reduceExpr.getConstant();

			var reduce = false;

			if(const.isBool())
			{
				reduce = const.parseBool();
			}


			return CString(type.getId(reduce)).at(); 
		}
		catch(e:Dynamic)
		{
			return CString(Std.string(e)).at();
		}
	}

}

private 