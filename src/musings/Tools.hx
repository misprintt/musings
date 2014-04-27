package musings;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Printer;
import haxe.macro.ExprTools;

typedef TExprTools = haxe.macro.ExprTools;
typedef TMacroStringTools = haxe.macro.MacroStringTools;
typedef TExprArrayTools = haxe.macro.ExprTools.ExprArrayTools;
typedef TTypeTools = haxe.macro.TypeTools;
typedef TComplexTypeTools = haxe.macro.ComplexTypeTools;

typedef TConstants = Constants;
typedef TFields = Fields;
typedef TPositions = Positions;
typedef TTypePaths = TypePaths;
typedef TExprs = Exprs;
typedef TTypes = Types;
typedef TComplexTypes = ComplexTypes;

@:ignoreCover
class Tools
{
	public static var printer:Printer = new Printer();


	public static function log(value:Dynamic, ?infos:haxe.PosInfos)
	{
		Sys.stdout().writeString(infos.fileName + ":" + infos.lineNumber + ": " + Std.string(value) + "\n");
	}

	public static function requiresMacro(?infos:haxe.PosInfos)
	{
		#if (!macro && !musings_test)
		log(infos.methodName + " requires macro context", infos);
		#end
	}

	/**
		Returns true if current target platform is static
		See <http://haxe.org/manual/basic_types#statically-typed-platforms>
	*/
	public static function isStaticPlatform():Bool
	{
		if(_isStaticPlatform == null)
		{
			_isStaticPlatform = false;
			var staticPlatforms = ["flash", "cpp", "java", "cs"];

			for(platform in staticPlatforms)
			{
				if(Context.defined(platform))
				{
					_isStaticPlatform = true;
					break;
				}
			}
		}
		return _isStaticPlatform;		
	}

	static var _isStaticPlatform:Null<Bool> = null;

}