## Musings

Utility library for manipulating Haxe 3 macro types.

A collection of `using` APIs that extend the functionality of `haxe.macro.Tools` for working with macro types.


Usage

	using musings.Tools;


Goals

- simpify manipulating macro types via `using`
- very granular APIs
- a fully unit tested macro library


Notes

> musings includes inlined aliases for some existing haxe.macro API methods in order to reduce to a single `using` dependency.


### Types

| method | description | example |
| -----| ------|-----|
|toType|Alias for `haxe.macro.Context.getType(`| `var type:Type = "foo.Bar".toType();`|
|getId|Convert a type to a string identifier| `var ident = type.getId(); //"foo.Bar"`|
|toString|Alias for `haxe.macro.TypeTools.toString`| `var string = type.toString();`|
|getClassType|Alias for `haxe.macro.TypeTools.getClass`| `var string = type.toString();`|
|getParams|Extracts an array of param types from a TInst type| `var params = type.getParams();`|
|toComplexType|Alias for `haxe.macro.TypeTools.toComplexType`| `var complexType = type.toComplexType();`|
|toTypeParam|Converts a Type to a TypeParam| `var typeParam = type.toTypeParam();`|



### ComplexTypes

| method | description | example |
| -----| ------|-----|
|toComplexType|Convert an ident to a ComplexType path| `var complexType = "foo.Bar".toComplexType();`|


### Exprs

| method | description | example |
| -----| ------|-----|
|toExpr|Converts an ExprDef [e] (and optional Position [pos]) into an Expr | `var e = EBlock([]).toExpr();`|
|at|Shorthand for `toExpr` for those familar with the tink macro api | `var e = EBlock([]).at();`|
|toFieldExpr|Converts a string ident into an EField | `var e = "foo".toFieldExpr();`|
|qualify|Explicitly qualifies type references within an expression tree (recursive)| `(macro Bar).toFieldExpr().qualify(); //foo.Bar`|
|reduce|Macro-time evaluation of expressions like binops, constants & mapped idents (recursive)| `(macro 1 + 2.5).reduce(); //3.5`|


### Constants

Converting `Constants` into other types

| method | description | example |
| -----| ------|-----|
|getConstant|returns the constant `c` within an `EConst` expression | `(macro "foo").getConstant;//CString("foo")` |
|at|Converts a `Constant` into an Expr | `CString("foo").at()` |
|toString|Alias for `haxe.macro.Printer.printConstant` | `CIdent("foo").toString()` |

Creating `Constants` from existing values

| method | description | example |
| -----| ------|-----|
|toConstant|returns a `CConst` based on value of `v` | `1.toConstant(); //CInt("1")` |
|toCIdent|similar to `toConstant` but will force string values to `CIdent` | `"foo".toCIdent()` |


Verifying the type of a `Constant`

| method | description | example |
| -----| ------|-----|
|isInt|Returns `true` if constant is of type `CInt` | `const.isInt();` |
|isFloat|Returns `true` if constnat is of type `CFloat` | `const.isFloat();` |
|isNumber|Returns `true` if constant is either a `CInt` or a `CFloat`| `const.isNumber();` |
|isString|Returns `true` if constant is of type `CString`| `const.isString();` |
|isIdent|Returns `true` if constant is of type `CIdent`| `const.isIdent();` |
|isBool|Returns `true` if constant is `CIdent("true")` or `CIdent("false")`| `const.isBool();` |
|isNull|Returns `true` if constant is `CIdent("null")`| `const.isNull();` |
|isRegexp|Returns `true` if constant is of type `CRegexp`| `const.isRegexp();` |

Extracting values from `Constants`

| method | description | example |
| -----| ------|-----|
|getValue|Returns the raw string value of a `Constant` | `CInt("1").getValue(); //"1"` |
|resolve|Returns the value defined in a `Constant` based on its tpye | `CFloat("1.5").resolve(); //1.5` |
|asInt|Returns `Int` value of a `CFloat` or 'CInt' | `CInt("1").asInt(); //1` |
|asFloat|Returns `Float` value of a `CFloat` or 'CInt' | `CFloat("1.5").asFloat(); //1.5` |
|asString|Returns `String` value of any `Constant` | `CIdent("foo").asString(); //"foo"` |
|asBool| Returns the `Bool` value of a `Constant` | `CIdent("true").asBool(); //true` |
|asRegexp|Returns the `EReg` value of a `Constant` | `CRegExpr(".*").asRegexpr();` |

