## Musings

Utility library for manipulating Haxe 3 macro types.

A collection of `using` APIs that extend the functionality of `haxe.macro.Tools` for working with macros. 

Usage

	using musings.Tools;


### Goals

- simpify manipulating macro types via `using`
- keep API as granular as possible, and use consistent langauge
- fully unit tested macro library


### Conventions

Operations that translate to a new object or value use the following prefix conventions

|prefix|description|example|
|---|----|---|
|to | convert to a specific type | `string.toType()`, `type.toString()`|
|get| extract a nested object or translate | `type.getId()`, `type.getParams()`|
|has| boolean check if contains value| `expr.hasConstant()` |
|is | boolean check if value is equal to | `const.isString()`|
|make| create a new object | `expr.makeFeild("foo")`|

Operations that effect the source object do not use prefixes

	expr.qualify()
	expr.reduce();


### Supported Types

- ComplexType
- Const
- Expr
- Field
- Position
- TypePath
- Type
