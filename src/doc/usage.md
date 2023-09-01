---
layout: default
title: "Usage"
nav_order: 4
---

# Usage
The `oal-client` crate contains two binaries, the command line interface and the LSP server.

## Command line interface
The `oal-cli` binary is the command line interface to the OAL compiler.

```
    oal-cli [OPTIONS]

OPTIONS:
    -b, --base <BASE>        The relative URL to a base OpenAPI description
    -c, --conf <CONFIG>      The path to the configuration file
    -h, --help               Print help information
    -m, --main <MAIN>        The relative URL to the main program
    -t, --target <TARGET>    The relative URL to the target OpenAPI description
```

## Configuration
A TOML configuration file can be provided instead of passing most command line arguments.
Example:

```toml
[api]
base = "base.yaml"
main = "main.oal"
target = "openapi.yaml"
```

## LSP server
The `oal-lsp` binary is the LSP server for integration with Visual Studio Code.
The installation path to the `oal-lsp` binary must be given to the [VSCode language extension](https://marketplace.visualstudio.com/items?itemName=e7bastien.oxlip-lang).