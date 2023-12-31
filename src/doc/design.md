---
layout: default
title: "Design decisions"
nav_order: 7
---

# Design decisions
If you are curious about some of the technical decisions behind Oxlip:
- Rust got chosen both as a learning material and because of the maturity of its ecosystem for the development of compilers.
- An external domain specific language was preferred to minimize dependencies with language SDKs and runtimes for end-users.
- The parser emits a concrete syntax tree instead of an abstract syntax tree to enable interactive source code refactoring capabilities.

---

[Next > Related work]({% link doc/related.md %})
