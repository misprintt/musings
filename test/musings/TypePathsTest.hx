package musings;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import haxe.macro.Expr;
import haxe.macro.Type;

import test.TestClasses;
using musings.Tools;

class TypePathsTest
{
	var typePath:TypePath;

	public function new()
	{

	}

	@Test
	public function shouldCreateTypePath()
	{
		typePath = "haxe.Log".toTypePath();

		Assert.areEqual(1, typePath.pack.length);
		Assert.areEqual("haxe", typePath.pack[0]);
		Assert.areEqual("Log", typePath.name);
		Assert.areEqual(null, typePath.sub);
		Assert.areEqual(0, typePath.params.length);
	}

	@Test
	public function shouldCreateTypePathWithParams()
	{
		var param:TypeParam = TPType(TPath("String".toTypePath()));
		typePath = "haxe.Log".toTypePath([param]);
		Assert.areEqual(1, typePath.params.length);
		Assert.areEqual(param, typePath.params[0]);
	}

	@Test
	public function shouldCreateTypePathWithSub()
	{
		typePath = "foo.bar.SomeType.Foo".toTypePath();
		Assert.areEqual(2, typePath.pack.length);
		Assert.areEqual("SomeType", typePath.name);
		Assert.areEqual("Foo", typePath.sub);
	}

	@Test
	public function shouldRemoveRedundantSubFromTypePath()
	{
		typePath = "haxe.Log.Log".toTypePath();
		Assert.areEqual("haxe", typePath.pack[0]);
		Assert.areEqual("Log", typePath.name);
		Assert.areEqual(null, typePath.sub);
	}

	@Test
	public function shouldReturnPathString()
	{
		typePath = "haxe.Log".toTypePath();
		Assert.areEqual("haxe.Log", typePath.toIdent());

	
		var param:TypeParam = TPType(TPath("String".toTypePath()));
		typePath = "haxe.Log".toTypePath([param]);

		Assert.areEqual("haxe.Log", typePath.toIdent());
	}

	@Test
	public function shouldPrint()
	{
		typePath = "haxe.Log".toTypePath();
		Assert.areEqual("haxe.Log", typePath.toString());

		var param:TypeParam = TPType(TPath("String".toTypePath()));
		typePath = "haxe.Log".toTypePath([param]);

		Assert.areEqual("haxe.Log<String>", typePath.toString());
	}

	@Test
	public function shouldQualifyTypePath()
	{
		Assert.areEqual("test.TestClasses.SomeClass", macro_qualify(SomeClass));
		Assert.areEqual("test.TestClasses.SomeClass", macro_qualify(test.SomeClass));
		// Assert.areEqual("test.TestClasses.SomeClass", macro_qualify(test.TestClasses.SomeClass));
	}

	macro static function macro_qualify(e:Expr):Expr
	{
		try
		{	var id = e.toString();
			var type = id.toType();
			var complexType = type.toComplexType();
			var typePath = id.toTypePath();

			return typePath.qualify().toString().toConstant().at();
		}
		catch(e:Dynamic)
		{
			return CString(Std.string(e)).at();
		}
	} 
}
		