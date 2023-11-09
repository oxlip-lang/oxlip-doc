---
layout: default
title: "Hello world"
nav_order: 5
---

# Hello World

Copy and paste the following line into a file named `hello.oal`:

```oal
res /hello on get -> { 'greetings [str] };
```

Run the Oxlip compiler:

```
oal-cli -m ./hello.oal -t hello.yaml
```

The corresponding OpenAPI definition is generated as `hello.yaml`:

```yaml
openapi: 3.0.3
info:
  title: OpenAPI definition
  version: 0.1.0
servers:
- url: /
paths:
  /hello:
    get:
      summary: get-hello
      operationId: get-hello
      responses:
        default:
          description: ''
          content:
            application/json:
              schema:
                type: object
                properties:
                  greetings:
                    type: array
                    items:
                      type: string
components: {}
```

---

[Next > Language overview]({% link doc/overview.md %})
