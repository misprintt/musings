package musings;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import haxe.macro.Expr;
import haxe.macro.Type;
import test.TestClasses;

using musings.Tools;

class ExprsTest
{

	public function new()
	{

	}

	@Test
	public function shouldConvertToExpr()
	{
		var pos:Position = Positions.makePos();
		
		var e = EContinue.toExpr();

		Assert.areEqual(EContinue, e.expr);
		Assert.isNotNull(e.pos);


		e = EContinue.toExpr(pos);
		Assert.areEqual(pos, e.pos); 
	}

	@Test
	public function shouldCreateExprAt()
	{
		var pos:Position = Positions.makePos();
		
		var e = EContinue.at();

		Assert.areEqual(EContinue, e.expr);
		Assert.isNotNull(e.pos);


		e = EContinue.at(pos);
		Assert.areEqual(pos, e.pos); 
	}

	@Test
	public function shouldReturnString()
	{
		var e = EContinue.at();

		Assert.areEqual("continue", e.toString());
	}

	@Test
	public function shouldResolve()
	{
		var pos = Positions.makePos();
		var expected = EField(CIdent("foo").at(pos), "Bar").at(pos);
		var actual = "foo.Bar".toFieldExpr(pos);

		Assert.areEqual(expected.toString(),actual.toString());
	}

	@Test
	public function shouldQualifyConstExpr()
	{
		Assert.areEqual("test.TestClasses.SomeClass", macro_qualify(SomeClass));
	}


	macro static function macro_qualify(e:Expr):Expr
	{
		try
		{
			return CString(e.qualify().toString()).at();
		}
		catch(e:Dynamic)
		{
			return CString(Std.string(e)).at();
		}
		
		
	}

	@Test
	public function shouldQualifyNewExpr()
	{
		Assert.areEqual("new test.TestClasses.SomeClass()", macro_qualify(new SomeClass()));
	}

	@Test
	public function shouldQualifyFieldExpr()
	{
		Assert.areEqual("test.TestClasses.SomeClass", macro_qualify(test.TestClasses.SomeClass));
	}

	@Test
	public function shouldReduceIntBinopExpr()
	{
		Assert.areEqual("2", macro_reduce(1 + 1));
	}

	@Test
	public function shouldReduceFloatBinopExpr()
	{
		Assert.areEqual("1.5", macro_reduce(1 + 0.5));
	}

	@Test
	public function shouldReduceStringBinopExpr()
	{
		Assert.areEqual("\"foobar\"", macro_reduce("foo" + "bar"));
	}

	@Test
	public function shouldReduceNestedExprs()
	{
		Assert.areEqual("[1.5,2]", macro_reduce([1+0.5, 2]));
	}


	macro static function macro_reduce(e:Expr):Expr
	{
		try
		{
			return CString(e.reduce().toString()).at();
		}
		catch(e:Dynamic)
		{
			return CString(Std.string(e)).at();
		}
	}
}
