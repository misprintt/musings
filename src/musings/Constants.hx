package musings;

import haxe.macro.Expr;
import haxe.macro.Type;

using musings.Tools;

/**
	This class provides some utility methods to work with Constant instances. It is
	best used through 'using musings.Constants' syntax and then provides
	additional methods on haxe.macro.Expr.Constant instances.
**/
class Constants
{
	/**
	Returns true if an expression is a EConst
	*/
	inline static public function hasConstant(e:Expr):Bool
	{
		return switch(e.expr)
		{
			case EConst(c): true;
			case _: false;
		}
	}


	/**
	Returns the Constant value within an expr [e].

	If [e] does not contain an EConst then result is null
	*/
	inline static public function getConstant(e:Expr):Constant
	{
		return switch(e.expr)
		{
			case EConst(c): c;
			case _: throw "EConst instance expected";
		}
	}

	/**
	Returns an expression containing constant [c].
	*/
	inline static public function at(c:Constant, ?pos:Position):Expr
	{
		return EConst(c).at(pos);
	}


	//-------------------------------------------------------------------------- check methods
	


	/**
	Returns a Constant based on the type of [v]

	If [ident] is true, then string values will be returned as CIdents rather than CString
	
	If [v] cannot be represented as a Constant then the result is null

	If [v] is an enum value then the enum value name is returned in a CIdent

	If [v] is an instance of a class (other than String) then the class name is
	returned in a CIdent
	*/
	static public function toConstant(v:Dynamic, ?ident:Bool=false):Constant
	{
		var s = Std.string(v);

		if(Std.is(v, Constant)) return cast v;

		return switch(std.Type.typeof(v))
		{
			case TNull: CIdent("null");
			case TInt: CInt(s);
			case TFloat: CFloat(s);
			case TBool: CIdent(s);
			case TClass(c): 
				var name = std.Type.getClassName(c).split(".").pop();
				if(name == "String")
					if(ident)
						CIdent(v)
					else
						CString(v);
				else
					CIdent(name);
			case TEnum(_): CIdent(s);
			case _: throw "Cannot convert [\"" + s + "\"] to Constant";
		}
	}

	
	/**
	Converts a string into a CIdent Constant
	*/
	inline static public function toCIdent(v:String):Constant
	{
		return v.toConstant(true);
	}


	/**
	Returns raw string value of constant [c].

	If [c] is of type CRegexp then result is represented using regexp syntax (~/r/opt) 
	*/
	static public function getValue(c:Constant):String
	{
		return switch(c)
		{
			case CInt(v): v;
			case CFloat(v): v;
			case CString(v): v;
			case CIdent(v): v;
			case CRegexp(r, opt): "~/" + r + "/" + opt;
			#if !haxe3
			case CType(s):s;
			#end
		}
	}

	/**
	Returns actual value defined in constant [c]

	If [c] is of type CIdent and is not a primitive value (true,false,null) then result is null 
	*/
	static public function toValue(c:Constant):Null<Dynamic>
	{
		return switch(c)
		{
			case CInt(_): c.getInt();
			case CFloat(_): c.getFloat();
			case CString(v): v;
			case CIdent(v):
				var r:Dynamic = switch(v)
				{
					case "true": true;
					case "false" : false;
					case "null" : null;
					default: null;
				}
				r;
			case CRegexp(_): c.getRegexp();
			#if !haxe3
			case CType(_): null;
			#end
		}
	}

	/**
	Returns a string representation of the constant [c] using haxe.macro.Printer
	*/
	inline static public function toString(c:Constant):String
	{
		return Tools.printer.printConstant(c);
	}

	//-------------------------------------------------------------------------- check methods

	/**
	Returns true if constant [c] is of type CInt
	*/
	inline static public function isInt(c:Constant):Bool
	{
		return switch(c)
		{
			case CInt(_): true;
			default: false;
		}
	}

	/**
	Returns true if constant [c] is of type CFloat
	*/
	inline static public function isFloat(c:Constant):Bool
	{
		return switch(c)
		{
			case CFloat(_): true;
			default: false;
		}
	}

	inline static public function isNumber(c:Constant):Bool
	{
		return c.isInt() || c.isFloat();
	}

	/**
	Returns true if constant [c] is of type CString
	*/
	inline static public function isString(c:Constant):Bool
	{
		return switch(c)
		{
			case CString(_): true;
			default: false;
		}
	}

	/**
	Returns true if constant [c] is of type CIdent
	*/
	inline static public function isIdent(c:Constant):Bool
	{
		return switch(c)
		{
			case CIdent(_): true;
			default: false;
		}
	}

	/**
	Returns true if constant [c] is of type CIdent("true") or CIdent("false")
	*/
	inline static public function isBool(c:Constant):Bool
	{
		return switch(c)
		{
			case CIdent("true"): true;
			case CIdent("false"): true;
			default: false;
		}
	}

	/**
	Returns true if constant [c] is of type CIdent("null")
	*/
	inline static public function isNull(c:Constant):Bool
	{
		return switch(c)
		{
			case CIdent("null"): true;
			default: false;
		}
	}

	/**
	Returns true if constant [c] is of type CRegexp
	*/
	inline static public function isRegexp(c:Constant):Bool
	{
		return switch(c)
		{
			case CRegexp(_): true;
			case _: false;
		}
	}

	//-------------------------------------------------------------------------- get methods

	/**
	Returns int value of constant [c]

	If [c] is not of type CInt then result is null
	*/
	inline static public function getInt(c:Constant):Int
	{
		return switch(c)
		{
			case CInt(v): Std.parseInt(v);
			case CFloat(v): Std.int(Std.parseFloat(v));
			case _: throw "Constant [\"" + c.toString() + "\"] cannot be parsed as Int";
		}
	}

	/**
	Returns float value of constant [c]

	If [c] is not of type CFloat or CInt then result is null
	*/
	inline static public function getFloat(c:Constant):Float
	{
		return switch(c)
		{
			case CFloat(v): Std.parseFloat(v);
			case CInt(v): Std.parseFloat(v);
			case _: throw "Constant [\"" + c.toString() + "\"] cannot be parsed as Float";
		}
	}

	/**
	Returns string value of constant [c]

	If [c] is not of type CString then result is null
	*/
	inline static public function getString(c:Constant):String
	{
		return getValue(c);
	}

	

	/**
	Returns bool value of constant [c]

	If [c] is not of type CIdent("true") or CIdent("false") then result is null
	*/
	inline static public function getBool(c:Constant):Bool
	{
		return switch(c)
		{
			case CIdent("true") : true;
			case CIdent("false") : false;
			case _: throw "Constant [\"" + c.toString() + "\"] cannot be parsed as Bool";
		}
	}

	/**
	Returns ereg value of constant [c]

	If [c] is not of type CRegexp then result is null
	*/
	inline static public function getRegexp(c:Constant):EReg
	{
		return switch(c)
		{
			case CRegexp(r,opt): new EReg(r, opt);
			case _: throw "Constant [\"" + c.toString() + "\"] cannot be parsed as EReg";
		}
	}

}
