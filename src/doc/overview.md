---
layout: default
title: "Overview of the language"
nav_order: 6
---

### Modules
Modules are imported with the `use` keyword.

```oal
use "some/other/module.oal";
```

### Primitives
Primitives are defined with the corresponding type keyword:
- `num` for floating point numbers
- `int` for integer numbers
- `bool` for booleans
- `str` for strings
- `uri` for URIs (`uri-reference` in OpenAPI)

```oal
let id1   = num `title: "some identifier"`;
let name  = str `pattern: "^[a-z]+$", example: sarah`;
let email = str `title: "E-mail address", format: email`;
```

### Properties
A property is a pair of name and schema type, with optional annotations.

```oal
# description: "some parameter"
let prop1 = 'id id1;

let prop2 = 'n num   `minimum: 0, maximum: 99.99, example: 42`;
let prop3 = 'age int `minimum: 0, maximum: 999`;
```

### Objects
Objects are collections of properties, separated by commas and enclosed with `{` and `}`.
Here the `@`-prefix denotes a reference variable whose value is registered as a component in the OpenAPI output.

```oal
# description: "some stuff"
let @obj1 = {
  'firstName! name    `title: "First name"`
, 'lastName! name     `title: "Last name"`
, 'middleNames [name] `title: "Middle names"`
, 'email email
};
```

### URIs
URIs are defined as sequences of path elements separated by `/`.
Templated elements are specified by a single property enclosed with `{` and `}`.

```oal
let uri1 = /some/path/{ prop1 }/template;
```

Unspecified URIs are simply defined with the primitive type `uri`.

```oal
let uri2 = uri;
```

### Recursion
In the top-level scope of a module, variables can be used before being defined.
Self-recursive or mutually recursive schemas can therefore be created by referring to each other variables.

As functions cannot be recursive, occasionally it is necessary to use the explicit recursion keyword `rec`.

```oal
let person = rec x { 'name name, 'children [x] };
```

### Contents
A content is the HTTP envelop of a schema, enclosed with `<` and `>`.
Schemas can be used in place of contents when no HTTP media type, status code or header is needed.

```oal
# description: "some trivial content"
# examples: { default: "examples/stuff.json" }
let cnt1 = <@obj1>;
```

### Operations
An operation is a transfer of state, in REST parlance.
It defines what content is accepted and returned for a set of HTTP methods.
It is possible to mention query string parameters as well.

```oal
# summary: "does something"
let op1 = patch, put { prop2 } : cnt1 -> cnt1;

# summary: "does something else", tags: [blah]
let op2 = get { 'q str } -> cnt1;
```

### Relations
A relation is a URI combined with one or more operations.
It corresponds to a pair of `path` and `path item` in OpenAPI.

```oal
let rel1 = uri1 on op1, op2;
```

### Schema operators
A conjunction of schemas is expressed with the operator `&`.
It corresponds to the `allOf` keyword in OpenAPI.

```oal
let @obj2 = @obj1 & { prop3 };
```

A disjunction or schemas is expressed with the operator `|`.
It corresponds to the `oneOf` keyword in OpenAPI.

```oal
let id2 = id1 | str;
```

Conjunctions and disjunctions are typed are object schemas.
An untyped schema combination can be expressed with the operator `~`.
It corresponds to the `anyOf` keyword in OpenAPI.

```oal
let any1 = id2 ~ @obj2 ~ uri1 ~ person;
```

### Functions
Functions are declared like variables but with parameter names that can be used in the right-hand-side.

```oal
let f x y = @obj2 & ( x | y );
```

Applying a function is done by passing parameters, simply separated by spaces.

```oal
# description: "some other stuff"
# examples: { default: "examples/other_stuff.json" }
let @obj3 = f { 'height num } { 'stuff any1 };
```

### Headers
HTTP headers are just properties, i.e. a name and a schema type, with optional annotations.

```oal
# description: "identifier for a specific version of a resource"
let etag = 'ETag! str `example: "675af34563dc-tr34"`;

# description: "makes the request conditional"
let ifnmatch = 'If-None-Match str;
```

### Media types
Media types variables are declared as literal strings.

```oal
let vendor = "application/vnd.blah+json";
let problem = "application/problem+json";
```

### Ranges
A range is a combination of the alternative contents that are returned by an operation.
Contents are combined with the `::` operator.

```oal
let with_err s = <status=200, media=vendor, headers={etag}, s>  `description: "all good"`
              :: <status=5XX, media=problem, {}>                `description: "internal error"`
              :: <status=4XX, media=problem, {}>                `description: "bad request"`
              :: <>                                             `description: "no content"`;
```
### Resources
The resources declared in the main program defines the relations that are to be exported as OpenAPI paths.
A resource declaration starts with the `res` keyword.

```oal
res rel1;

res /something?{ 'q! str } on get : <headers={ifnmatch}> -> with_err @obj3;
```

### Comments
```oal
// Line comment
/*
 * Block
 * comment
 */
```
