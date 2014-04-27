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

		Assert.areEqual("\"" + expected.toString() + "\"",macro_toFieldExpr("foo.Bar"));
	}

	macro static function macro_toFieldExpr(e:Expr):Expr
	{
		try
		{
			var expr = e.toString().toFieldExpr();
			return CString(expr.toString()).at();
		}
		catch(e:Dynamic)
		{
			return CString(Std.string(e)).at();
		}
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
		Assert.areEqual("[1.5, 2]", macro_reduce([1+0.5, 2]));
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

	// ------------------------------------------------------------------------- ExprDef manipulation


	@Test
	public function should_get_field()
	{
		var pos = Positions.makePos();
		var expr:Expr = CIdent("foo").at(pos);
		var expected = EField(expr, "Bar").at(pos);

		var result = expr.makeField("Bar", pos);

		Assert.areEqual(expected.toString(), result.toString());
	}

	@Test
	public function should_get_call()
	{
		var pos = Positions.makePos();
		var expr:Expr = CIdent("foo").at(pos);
		var expected = ECall(expr, []).at(pos);

		var result = expr.makeCall([], pos);

		Assert.areEqual(expected.toString(), result.toString());
	}

	@Test
	public function should_convert_to_arrayDecl()
	{
		var pos = Positions.makePos();
		var expr:Expr = CIdent("foo").at(pos);
		var exprs:Array<Expr> = [expr];
		var expected = EArrayDecl(exprs).at(pos);

		var result = exprs.makeArray(pos);

		Assert.areEqual(expected.toString(), result.toString());
	}

}
