## Musings

Utility library for manipulating Haxe 3 macro types.

A collection of `using` APIs that extend the functionality of `haxe.macro.Tools` for working with macros. 

Usage

	using musings.Tools;


Goals

- simpify manipulating macro types via `using`
- keep API as granular as possible
- a fully unit tested macro library


Notes

> musings includes inlined aliases for some existing haxe.macro API methods in order to simplify the number of `using` dependencies.


### Types


Creating `Type` instances from other value types


- **toType** - Alias for `haxe.macro.Context.getType`

		var type:Type = "foo.Bar".toType();


Convert `Type` instances into other value types


- **getId** - Convert a type to a string identifier

		var ident = type.getId(); //"foo.Bar"

- **toString** - Alias for `haxe.macro.TypeTools.toString`

		var string = type.toString();

- **toComplexType** - Alias for `haxe.macro.TypeTools.toComplexType`

		var complexType = type.toComplexType();

- **toTypeParam** - Converts a Type to a TypeParam
		
		var typeParam = type.toTypeParam();



Extracting values from `Type` instances

- **getClassType** - Alias for `haxe.macro.TypeTools.getClass`		
		
		var string = type.toString();

- **getParams** - Extracts an array of param types from a TInst type		
		
		var params = type.getParams();




### ComplexTypes

- **toComplexType** - Convert an ident to a ComplexType path	

		var complexType = "foo.Bar".toComplexType();


### Exprs

Converting `Expr` into other types

- **toExpr** - Converts an ExprDef [e] (and optional Position [pos]) into an Expr
		
		var e = EBlock([]).toExpr();

- **toFieldExpr** - Converts a string ident into an EField

		var e = "foo".toFieldExpr();

- **at** - Shorthand for `toExpr` for those familar with the tink macro api

		var e = EBlock([]).at();

Manipulating `Expr` contents

- **qualify** - Explicitly qualifies type references within an expression tree (recursive)
		
		(macro Bar).toFieldExpr().qualify(); //foo.Bar

- **reduce** - Macro-time evaluation of expressions like binops, constants & mapped idents (recursive)
		
		(macro 1 + 2.5).reduce(); //3.5


### Constants

Converting `Constants` into other types

- **getConstant** - Returns the constant `c` within an `EConst` expression
		
		(macro "foo").getConstant;//CString("foo")

- **at** - Converts a `Constant` into an Expr
		
		CString("foo").at();

- **toString** - Alias for `haxe.macro.Printer.printConstant`
		
		CIdent("foo").toString();

Creating `Constants` from existing values

- **toConstant** - returns a `CConst` based on value of `v`
		
		1.toConstant(); //CInt("1")

- **toCIdent** - similar to `toConstant` but will force string values to `CIdent`
		
		"foo".toCIdent();


Verifying the type of a `Constant`

- **isInt** - Returns `true` if constant is of type `CInt`
		
		const.isInt();		

- **isFloat** - Returns `true` if constnat is of type `CFloat`
		
		const.isFloat();		

- **isNumber** - Returns `true` if constant is either a `CInt` or a `CFloat`
		
		const.isNumber();		

- **isString** - Returns `true` if constant is of type `CString`
		
		const.isString();		

- **isIdent** - Returns `true` if constant is of type `CIdent`
		
		const.isIdent();		

- **isBool** - Returns `true` if constant is `CIdent("true")` or `CIdent("false")`
		
		const.isBool();		

- **isNull** - Returns `true` if constant is `CIdent("null")`
		
		const.isNull();		

- **isRegexp** - Returns `true` if constant is of type `CRegexp`
		
		const.isRegexp();		


Extracting values from `Constants`

- **getValue** - Returns the raw string value of a `Constant`
		
		CInt("1").getValue(); //"1"		

- **resolve** - * - Returns the value defined in a `Constant` based on its type
		
		CFloat("1.5").resolve(); //1.5		

- **asInt** - Returns `Int` value of a `CFloat` or 'CInt'
		
		CInt("1").parseInt(); //1		

- **asFloat** - Returns `Float` value of a `CFloat` or 'CInt'
		
		CFloat("1.5").parseFloat(); //1.5		

- **asString** - Returns `String` value of any `Constant`
		
		CIdent("foo").parseString(); //"foo"		

- **asBool** -  Returns the `Bool` value of a `Constant`
		
		CIdent("true").parseBool(); //true		

- **asRegexp** - Returns the `EReg` value of a `Constant`
		
		CRegExpr(".*").parseRegexpr();		



### Fields

Converting `Field` instance into other types

- **toString** - Returns a `String` representation of a Field (Alias for `haxe.macro.Printer.printField`)
		
		field.toString();		


Creating `Field` instance from existing values

- **toField** - Returns a `Field` based of a `name` and `FieldKind`
		
		"foo".toField(fieldKind);		

- **clone** - Returns a copy of a field
		
		field.clone();		



Extracting properties of a `Field` instance


- **getExpr** - returns the `Expr` defined on a field
		
		field.getExpr();		

- **getComplexType** - Returns the `ComplexType` of a field
		
		field.getComplexType();		

