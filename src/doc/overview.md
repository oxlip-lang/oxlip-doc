---
layout: default
title: "Overview of the language"
nav_order: 6
---

# Overview of the language
{: .no_toc }

<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
- TOC
{:toc}
</details>

### Programs
A program is a collection of statements.
There are three types of statements:
- imports (`use`)
- declarations (`let`)
- resources (`res`)

Statements only appear in the top-level scope of a program and end with a `;`.

### Modules
Modules are imported with the `use` keyword.
Importing makes the variables and functions declared in the module available in the current top-level scope.
Resources declared with the `res` keyword are not imported.

```oal
use "some/other/module.oal";
```

A module can be imported in a namespace with the `as` keyword:

```oal
use "some/other/module.oal" as m;
```

### Declarations
Variables and functions are declared with the `let` keyword.
Referring to declarations imported in a namespace is done by prefixing the name with the namespace, separated with a full stop, as in `namespace.declaration`.

So-called _reference variables_ starts with an `@` and are registered as components in the OpenAPI output.

### Resources
The resources declared in the main program identify the relations that are to be exported as OpenAPI paths.
A resource declaration starts with the `res` keyword.

```oal
res rel1;

res /something?{ 'q! str } on get : <headers={ifnmatch}> -> respond @obj3;
```

### Annotations
Expressions and declarations can be annotated to provide OpenAPI and JSON Schema metadata.

Inline annotations immediately follow the expression they refer to and are enclosed with backticks:
```oal
let a = num `title: some identifier`;
```

Line annotations come before the declaration or expression they refer to and start with `#`:
```oal
# title: some identifier
# pattern: "^[a-z]+$", example: sarah
let b  = str;
```

The format of an annotation is an inline YAML object without enclosing braces.
The supported annotation properties are:
- All schema expressions:
  - `description`
  - `title`
  - `required`
  - `examples`
- URI schema:
  - `example` (default auto-generated)
- Integer and number schema:
  - `minimum`
  - `maximum`
  - `multipleOf`
  - `example`
- String schema:
  - `pattern`
  - `enum`
  - `format`
  - `example`
  - `minLength`
  - `maxLength`
- Content:
  - `description`
  - `examples`
- Property:
  - `description`
  - `required` (_deprecated_)
- Transfer (a.k.a operation):
  - `description`
  - `summary`
  - `tags`
  - `operationId` (default auto-generated)

Please refer to the [OpenAPI specification](https://spec.openapis.org/oas/v3.0.3#properties) for a detailed description.

### Types
Types are inferred for all expressions and are not part of the syntax. Error messages may refer to them when inference fails due to types mismatch.
The supported types are:
- `Text`, the literal string type;
- `Number`, the literal integer number type;
- `Status`, the literal HTTP status code type;
- `Primitive`, the primitive schema type;
- `Relation`, the relation type;
- `Object`, the object schema type;
- `Content`, the content type;
- `Transfer`, the transfer or operation type;
- `Array`, the array schema type;
- `Uri`, the URI schema type;
- `Any`, the catch-all schema type;
- `Property<T>`, the property type, parameterized with the type `T` of the inner schema;
- `Func<[B], R>`, the function type, parameterized with the parameter types `[B]`, and returned type `R`.

### Primitives
Primitive schema types are defined with the corresponding keyword:
- `num` for floating point numbers;
- `int` for integer numbers;
- `bool` for booleans;
- `str` for strings;
- `uri` for URIs, which corresponds to `uri-reference` in OpenAPI.

```oal
let id1   = num `title: some identifier`;
let name  = str `pattern: "^[a-z]+$", example: sarah`;
let email = str `title: "E-mail address", format: email`;
```
### URIs
Specific URIs and URI templates are defined as sequences of path elements separated by `/`.
Templatized elements are specified by a single property enclosed with `{` and `}`.

```oal
let uri1 = /some/path/{ prop1 }/template;
```

Unspecified URIs are simply defined with the primitive type `uri`.

```oal
let uri2 = uri;
```

### Arrays
An array schema is defined by enclosing a schema expression with `[` and `]`.

```oal
let a = [num];
```

### Properties
A property is a pair of name and schema type. The property name is indicated with a single quote. A property can be _required_ or _optional_ (default), indicated with respectively a `!` or a `?` immediately after the property name.

```oal
# description: "some parameter"
let prop1 = 'id id1;

let prop2 = 'n num    `minimum: 0, maximum: 99.99, example: 42`;
let prop3 = 'age! int `minimum: 0, maximum: 999`;
```

### Objects
Object schemas are collections of properties, separated by commas and enclosed with `{` and `}`.

```oal
# description: "some stuff"
let @obj1 = {
  'firstName! name    `title: First name`,
  'lastName! name     `title: Last name`,
  'middleNames [name] `title: Middle names`,
  'email email        `title: E-mail address`,
};
```

### Headers
HTTP headers are just properties, i.e. a name and a schema type.

```oal
# description: "identifier for a specific version of a resource"
let etag = 'ETag! str `example: "675af34563dc-tr34"`;

# description: "makes the request conditional"
let ifnmatch = 'If-None-Match str;
```

### Media types
Media types are expressed as literal strings.

```oal
let vendor = "application/vnd.blah+json";
let problem = "application/problem+json";
```
### Status codes
HTTP status code are expressed as literal integer numbers or ranges.

```oal
let ok = 200;
let badRequest = 4XX;
```

### Contents
A content is the HTTP envelop of a schema.
It is an optional list of HTTP attributes separated by commas, followed by a schema expression, and enclosed with `<` and `>`.
The possible HTTP attributes are:
- `status`, to specify an HTTP status code or range of codes;
- `media`, to specify an HTTP media type;
- `headers`, to specify a collection of headers enclosed with `{` and `}`.

Contents are used to specify request and response bodies. HTTP status codes are only meaningful in the context of a response body.
Schema expressions can be used in place of contents when no HTTP attribute is needed.

```oal
# description: "some trivial content"
# examples: { default: "examples/stuff.json" }
let cnt1 = <status=200, media=vendor, headers={etag}, @obj1>;
```

### Operations (a.k.a transfers)
An operation is a transfer of state, in REST parlance.
It defines what content (or range) is accepted and/or returned for a set of HTTP methods.
The _query string_ parameters are declared as a list of properties enclosed with `{` and `}` and following the HTTP methods.
When applicable, the content of the HTTP request body comes before the `->`, separated by a `:`.

```oal
# summary: "does something"
let op1 = patch, put { prop2 } : cnt1 -> cnt1;

# summary: "does something else", tags: [blah]
let op2 = get { 'q str } -> cnt1;
```

### Relations
A relation is a URI combined with one or more operations that are supported by this HTTP end-point.
It corresponds to a pair of _path_ and _path item_ in OpenAPI.
Exporting a relation with the `res` keyword promotes it to a _resource_.

```oal
let rel1 = uri1 on op1, op2;
```

A relation can be used as a schema expression to constrain the set of valid operations on a URI schema.
Across a domain, this effectively defines the graph of possible state transitions between resources in a [HATEOAS](https://en.wikipedia.org/wiki/HATEOAS) system.

{: .note }
There is no _relation_ schema in OpenAPI. When used as a schema, only the URI part of a relation is preserved.
Next to OpenAPI, OAL is experimenting with complementary formats to retain the state transition information in the compiler output.

### Schema operators
A conjunction of schemas is expressed with the `&` operator.
It corresponds to the _allOf_ combination in OpenAPI. Both schemas must be of the object type.

```oal
let @obj2 = @obj1 & { prop3 };
```

A disjunction of schemas is expressed with the `|` operator.
It corresponds to the _oneOf_ combination in OpenAPI. Both schemas must be of the same type.

```oal
let id2 = id1 | str;
```

An untyped schema alternative can be expressed with the `~` operator.
It corresponds to the _anyOf_ combination in OpenAPI.

```oal
let any1 = id2 ~ @obj2 ~ uri1;
```

### Property operators
The _required_ and _optional_ traits of a property can be altered with the unary `!` and `?` operators.

```oal
let a = 'prop! num; // Property is required
let b = a ?;        // Property is optional
let c = b !;        // Property is required
```

### Functions
Functions are declared like variables but with parameter names that can be used in the right-hand-side.

```oal
let f x y = @obj2 & ( x | y );
```

Applying a function is done by listing parameters after the function name, separated by spaces.

```oal
# description: "some other stuff"
# examples: { default: "examples/other_stuff.json" }
let @obj3 = f { 'height num } { 'stuff any1 };
```

### Ranges
A range is a combination of alternative contents that can be returned by an operation.
Contents are combined with the `::` operator.

```oal
let respond s = <status=200, media=vendor, headers={etag}, s> `description: "all good"`
             :: <status=5XX, media=problem, {}>               `description: "internal error"`
             :: <status=4XX, media=problem, {}>               `description: "bad request"`
             :: <>                                            `description: "no content"`;
```

### Comments
```oal
// Line comment
/*
 * Block
 * comment
 */
```

### Recursion
In the top-level scope of a module, variables can be used before being defined.
Self-recursive or mutually recursive schemas can therefore be created by referring to the corresponding variables.

As functions cannot be recursive, occasionally it is necessary to use the explicit recursion keyword `rec`:

```oal
let person n = rec x { 'name n, 'children [x] };
```

---

[Next > Design decisions]({% link doc/design.md %})
