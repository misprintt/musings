package musings;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import haxe.macro.Expr;
import haxe.macro.Type;

import test.TestClasses;
using musings.Tools;

class ConstantsTest
{

	static var INT = CInt("1");
	static var FLOAT = CFloat("1.1");
	static var STRING = CString("foo");
	static var TRUE = CIdent("true");
	static var FALSE = CIdent("false");
	static var NULL = CIdent("null");
	static var VAR = CIdent("foobar");
	static var REGEXP = CRegexp("f.*", "i");


	public function new()
	{

	}

	@Test
	public function shouldParseConstant()
	{
		var expr = {expr:EConst(INT), pos:null};
		Assert.areEqual(INT, expr.getConstant());
	}


	@Test
	public function shouldReturnTrueIfEConst()
	{
		var expr = {expr:EConst(INT), pos:null};
		Assert.isTrue(expr.hasConstant());
	}


	@Test
	public function shouldReturnFalseIfNotEConst()
	{
		var expr = {expr:EContinue, pos:null};
		Assert.isFalse(expr.hasConstant());
	}


	@Test
	public function shouldThrowExceptionIfExprIsNotEConst()
	{
		try
		{
			var expr = {expr:EContinue, pos:null};
			expr.getConstant();
			Assert.fail("exception expected");
		}
		catch(e:Dynamic) {

			Assert.isTrue(true);
		}

		
	}

	@Test
	public function shouldBeInt()
	{
		Assert.isTrue(INT.isInt());
		Assert.isFalse(STRING.isInt());
	}

	@Test
	public function shouldBeFloat()
	{
		Assert.isTrue(FLOAT.isFloat());
		Assert.isFalse(STRING.isFloat());
	}

	@Test
	public function shouldBeString()
	{
		Assert.isTrue(STRING.isString());
		Assert.isFalse(FLOAT.isString());
	}

	@Test
	public function shouldBeIdent()
	{
		Assert.isTrue(TRUE.isIdent());
		Assert.isTrue(FALSE.isIdent());
		Assert.isTrue(VAR.isIdent());
		Assert.isTrue(NULL.isIdent());
		Assert.isFalse(STRING.isIdent());
	}

	@Test
	public function shouldBeBool()
	{
		Assert.isTrue(TRUE.isBool());
		Assert.isTrue(FALSE.isBool());
		Assert.isFalse(STRING.isBool());
	}

	@Test
	public function shouldBeNull()
	{
		Assert.isTrue(NULL.isNull());
		Assert.isFalse(STRING.isNull());
	}

	@Test
	public function shouldBeRegexp()
	{
		Assert.isTrue(REGEXP.isRegexp());
		Assert.isFalse(STRING.isRegexp());
	}

	@Test
	public function shouldBeNumber()
	{
		Assert.isTrue(INT.isNumber());
		Assert.isTrue(FLOAT.isNumber());
		Assert.isFalse(STRING.isNumber());
	}

	//-------------------------------------------------------------------------- accessing constant values

	@Test
	public function shouldParseInt()
	{
		try
		{
			Assert.isNull(STRING.parseInt());
			Assert.fail("exception expected");
		}
		catch(e:Dynamic) {}

		Assert.areEqual(1, INT.parseInt());
		Assert.areEqual(1,FLOAT.parseInt());
		
	}

	@Test
	public function shouldParseFloat()
	{
		try
		{
			Assert.isNull(STRING.parseFloat());
			Assert.fail("exception expected");
		}
		catch(e:Dynamic) {}

		Assert.areEqual(1.1, FLOAT.parseFloat());
		Assert.areEqual(1.0, INT.parseFloat());
	}

	@Test
	public function shouldParseString()
	{
		Assert.areEqual("foo", STRING.parseString());
		Assert.areEqual("1.1", FLOAT.parseString());
	}

	@Test
	public function shouldParseBool()
	{
		try
		{
			Assert.isNull(STRING.parseBool());
			Assert.fail("exception expected");
		}
		catch(e:Dynamic) {}

		Assert.isTrue(TRUE.parseBool());
		Assert.isFalse(FALSE.parseBool());
	}

	@Test
	public function shouldParseRegexp()
	{
		try
		{
			Assert.isNull(STRING.parseRegexp());
			Assert.fail("exception expected");
		}
		catch(e:Dynamic) {}

		var reg = REGEXP.parseRegexp();
		Assert.isNotNull(reg);
		Assert.isTrue(reg.match("Foo"));
		Assert.isFalse(reg.match("bar"));
	}

	@Test
	public function shouldGetValue()
	{
		Assert.areEqual("true", TRUE.getValue());
		Assert.areEqual("false", FALSE.getValue());
		Assert.areEqual("null", NULL.getValue());
		Assert.areEqual("1", INT.getValue());
		Assert.areEqual("1.1", FLOAT.getValue());
		Assert.areEqual("foo", STRING.getValue());
		Assert.areEqual("~/f.*/i", REGEXP.getValue());
	}

	@Test
	public function shouldResolve()
	{
		Assert.areEqual(true, TRUE.resolve());
		Assert.areEqual(false, FALSE.resolve());
		Assert.areEqual(null, NULL.resolve());
		Assert.areEqual(1, INT.resolve());
		Assert.areEqual(1.1, FLOAT.resolve());
		Assert.areEqual("foo", STRING.resolve());
		
		var reg = REGEXP.resolve();
		Assert.isNotNull(reg);
		Assert.isTrue(reg.match("Foo"));
		Assert.isFalse(reg.match("bar"));

		Assert.areEqual(null, VAR.resolve());
	}

	@Test
	public function shouldCreateConstant()
	{

		try
		{
			Assert.isNull({foo:"bar"}.toConstant());//cannot be represented as a constant
			Assert.fail("exception expected");
		}
		catch(e:Dynamic) {}


		Assert.areEqual(TRUE, true.toConstant());
		Assert.areEqual(FALSE, false.toConstant());

		Assert.areEqual(NULL, Constants.toConstant(null));

		Assert.areEqual(INT, 1.toConstant());
		Assert.areEqual(FLOAT, 1.1.toConstant());
		Assert.areEqual(STRING, "foo".toConstant());


		Assert.areEqual(INT, INT.toConstant());//should return existing constant

		Assert.areEqual(CIdent("a"), TestEnum.a.toConstant());

		Assert.areEqual(CIdent("Test"), new Test().toConstant());
		Assert.areEqual(CIdent("Test"), "Test".toCIdent());

		Assert.areEqual(VAR, "foobar".toConstant(true));
	}

	@Test
	public function shouldPrintToString()
	{
		Assert.areEqual("\"foo\"", STRING.toString());
		Assert.areEqual("1", INT.toString());
	}
}

private enum TestEnum
{
	a;
	b;
}

private class Test
{
	public function new()
	{

	}
}