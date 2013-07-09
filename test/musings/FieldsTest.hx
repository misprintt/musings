package musings;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import haxe.macro.Expr;
import haxe.macro.Type;

import test.TestClasses;
using musings.Tools;
using haxe.EnumTools.EnumValueTools;

class FieldsTest
{
	var pos:Position;
	var expr:Expr;
	var type:ComplexType;
	var func:Function;

	var fVar:Field;
	var fProp:Field;
	var fFun:Field;

	var fUntypedVar:Field;

	public function new()
	{

	}

	@Before
	public function setup():Void
	{
		pos = {file:"field.hx", min:0, max:0};
		expr = CInt("1").at();
		type = TPath({pack:[],name:"Test",params:[],sub:null});

		fVar =  {
			name:"variable",
			kind:FVar(type, expr),
			pos:pos,
		};

		fUntypedVar = {
			name:"anon",
			kind:FVar(null,null),
			pos:pos
		}

		fProp =  {
			name:"property",
			kind:FProp("default","null",type, expr),
			pos:pos
		};

		func = {
			args:[],
			ret: type,
			expr: expr,
			params:[]
		}

		fFun =  {
			name:"function",
			kind:FFun(func),
			pos:pos
		};
	}

	@Test
	public function shouldReturnFieldExpr()
	{
		Assert.areEqual(expr, fVar.getExpr());
		Assert.areEqual(expr, fProp.getExpr());
		Assert.areEqual(expr, fFun.getExpr());
		Assert.areEqual(null, fUntypedVar.getExpr());
	}


	@Test
	public function shouldReturnFieldComplexType()
	{
		Assert.areEqual(type, fVar.getComplexType());
		Assert.areEqual(type, fProp.getComplexType());
		Assert.areEqual(type, fFun.getComplexType());
		Assert.areEqual(null, fUntypedVar.getComplexType());
	}


	@Test
	public function shouldCreateField()
	{
		var field = "test".toField(fVar.kind);

		Assert.isNotNull(field);
		Assert.areEqual("test", field.name);
		Assert.areEqual(fVar.kind, field.kind);
	}

	@Test
	public function shouldCreateFieldWithVariable()
	{
		var field = "test".toField();


		Assert.isNotNull(field);
		Assert.isNotNull(field.kind);
		Assert.isTrue(field.kind.equals(FVar(null,null)));
	}

	@Test
	public function shouldCloneField()
	{
		var clone = fVar.clone();

		Assert.areNotEqual(fVar,clone);
		Assert.areEqual(fVar.name, clone.name);

		clone.meta = [];
		clone.access = [AStatic];

		clone = clone.clone();

	}

	@Test
	public function shouldPrint()
	{
		Assert.areEqual("var field", "field".toField().toString());
		Assert.areEqual("var variable:Test=1", fVar.toString());
		Assert.areEqual("var property(default,null):Test=1", fProp.toString());
	}

}