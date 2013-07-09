package musings;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

using musings.Tools;

/**
	This class provides some utility methods to work with Position instances. It is
	best used through 'using musings.Positions' syntax and then provides
	additional methods on haxe.macro.Expr.Positions instances.

	It also avoids calling Context APIs when not executing within the macro context,
	allowing unit testing of macro related code.

	Generally used internally within other musing classes
**/

class Positions
{
	/**
	Returns the position [pos] or creates a new one based on current location.

	If not called within a macro, uses the posInfos of the callee
	*/
	inline static public function getPos(?pos:Position, ?infos:haxe.PosInfos):Position
	{
		#if macro
		return pos != null ? pos : Context.currentPos();
		#else
		return pos != null ? pos : makePos(infos.fileName);
		#end
	}

	/**
	Creates a new position based on a [file], [min] and [max] character position.
	*/
	inline static public function makePos(?file:String, ?min:Int=0, ?max:Int=0, ?infos:haxe.PosInfos):Position
	{
		if(file == null) file = infos.fileName;

		#if macro
		return Context.makePosition({min:min, max:max, file:file});
		#else
		return {file:file, min:min, max:max};
		#end
	}
}