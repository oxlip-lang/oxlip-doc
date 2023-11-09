---
layout: default
title: "Related work"
nav_order: 8
---

# Related work and comparison with Oxlip

## [TypeSpec](https://github.com/microsoft/typespec) / [Smithy IDL](https://github.com/awslabs/smithy)

Arguably, TypeSpec and Smithy provide an opinionated service interface abstraction
that happens to compile down to an OpenAPI definition.
As they take on a broader scope than REST APIs (e.g. GraphQL, gRPC),
it is not their objective to behave as a preprocessor and to offer feature parity with OpenAPI.
The language design philosophy for both TypeSpec and Smithy looks similar and
influenced by familiar object-oriented and general purpose languages.
TypeSpec's support for parameterized data types (aka. templates) makes it more programmable than Smithy.

## [KCL](https://github.com/KusionStack/KCLVM) / [CUE](https://github.com/cue-lang/cue) / [Dhall](https://github.com/dhall-lang/dhall-lang)

KCL, CUE and Dhall belong to a different category of languages focusing on programmable configuration.
Their domain of concern is the management and validation of configuration files at scale,
e.g. JSON or YAML files for large Kubernetes deployments.
The approach is to define a higher-level language with functions, types, modules and data constraints,
able to compile down to the target configuration format.
It obviously applies to the generation of OpenAPI definitions by the very nature of the OpenAPI specification being a JSON-based format.
That being said, REST concepts are not first-class citizen for those languages.
The domain of programmability only applies to the generation of JSON/YAML objects, lists and scalar values.
It does not directly model the composition of REST entities as a service interface definition.

## [ResponsibleAPI](https://github.com/responsibleapi/responsible)

_(TBD)_

## [Oxlip API Language](https://doc.oxlip-lang.org)

Oxlip takes a different approach by defining an algebra and a functional evaluation strategy
dedicated to the composition of low-level REST concepts into modular OpenAPI definitions.
One can argue that extensible languages like Dhall could achieve similar objectives.
As a specialized language, Oxlip has the potential to provide a more compact syntax,
easier to learn, to read and to manage at scale.

---

[Next > Examples]({% link doc/examples.md %})
