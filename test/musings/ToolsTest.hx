package musings;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import haxe.macro.Expr;
import haxe.macro.Type;
import test.TestClasses;

using musings.Tools;

class ToolsTest
{
	public function new()
	{

	}

	@Test
	public function should_return_staticPlatform()
	{
		#if (flash || cpp || java || cs)
		Assert.isTrue(macro_isStaticPlatform());
		#else
		Assert.isFalse(macro_isStaticPlatform());
		#end
	}

	macro static function macro_isStaticPlatform():Expr
	{
		try
		{
			var result = Std.string(Tools.isStaticPlatform());
			return EConst(CIdent(result)).at();
		}
		catch(e:Dynamic)
		{
			return Std.string(e).toConstant().at();
		}
	}
}
