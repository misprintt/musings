package musings;

import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Context;

using musings.Tools;

/**
	This class provides some utility methods to work with TypePath instances. It is
	best used through 'using musings.TypePaths' syntax and then provides
	additional methods on haxe.macro.Expr.TypePaths instances.

**/
class TypePaths
{
	/**
		Returns a string representation of typePath [tp] without paramaters;
	*/
	inline static public function toIdent(tp:TypePath)
	{
		tp = {pack:tp.pack, name:tp.name, sub:tp.sub, params:[]};
		return tp.toString();
	}
	
	/**
		Returns a string representation of typePath [tp] (including paramaters);
	*/
	inline static public function toString(tp:TypePath):String
	{
		return Tools.printer.printTypePath(tp);
	}

	/**
		Returns a TypePath for the string [ident], and optional paramaters [params]
	*/
	static public function toTypePath(ident:String, ?params:Array<TypeParam>):TypePath
	{
		if(params == null) params = [];

		var parts:Array<String> = ident.split(".");
		var sub:String = null;
		var name:String = parts.pop();

		if(parts.length > 0)
		{
			var char = parts[parts.length-1].split("").shift();
			
			if(char == char.toUpperCase())
			{
				sub = name;
				name = parts.pop();
			}
		}

		if(sub == name)
			sub = null;

		return {
			sub:sub,
			pack:parts,
			name:name,
			params:params
		}

	}

	#if macro
	static public function qualify(tp:TypePath):TypePath
	{
		var ident = tp.toString();
		var type = Context.getType(ident);

		var ct = type.toComplexType();

		return ct.toString().toTypePath();
	}
	#end
}
