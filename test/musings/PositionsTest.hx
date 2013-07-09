package musings;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import haxe.macro.Expr;
import haxe.macro.Type;

using musings.Tools;

class PositionsTest
{
	static var FILE = "file.hx";

	public function new()
	{

	}

	@Test
	public function shouldMakePosFromFile()
	{
		var pos = FILE.makePos(1, 10);

		Assert.areEqual(FILE, pos.file);
		Assert.areEqual(1, pos.min);
		Assert.areEqual(10, pos.max);
	}

	@Test
	public function shouldMakePosWithoutFile()
	{
		var pos = Positions.makePos(null, 1, 10);

		Assert.areEqual("PositionsTest.hx", pos.file);
		Assert.areEqual(1, pos.min);
		Assert.areEqual(10, pos.max);
	}

	@Test
	public function shoulGetExistingPos()
	{
		var pos = FILE.makePos();
		Assert.areEqual(pos, pos.getPos());
	}

	@Test
	public function shouldGetNewPos()
	{
		var pos:Position = null;

		pos = pos.getPos();

		Assert.isNotNull(pos);
		Assert.areEqual("PositionsTest.hx", pos.file);
	}

	

}