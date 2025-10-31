# integratify-workflow

Use case example for [integratify](https://github.com/zinrai/integratify) - validating middleware HTTP API responses.

## Problem

When migrating middleware systems, you need to verify that the target environment
is production-ready. This verification should be:

- Reproducible: Same checks executed consistently
- Automated: Not a manual checklist
- Reliable: Catch issues before production deployment

Manual inspection is error-prone and doesn't scale. You need automated validation
with clear pass/fail criteria.

## Solution

Three-step automated workflow:

```
HTTP API -> JSON -> Validation -> Pass/Fail
```

1. Fetch JSON from HTTP API
2. Validate against CUE schema
3. Report results (exit code 0 or 1)

## Example: Consul Raft Configuration

This repository demonstrates the pattern using Consul as a concrete example.

**Validation rules:**
- Exactly one server with `Leader: true`
- All servers have identical `LastIndex` values

**What's provided:**
- `docker-compose.yml` - 5-node Consul cluster
- `raft-config.cue` - CUE validation schema
- `Taskfile.yml` - Workflow definition

## Prerequisites

This implementation uses:

| Component       | Choice                                               | Alternatives                                  |
|-----------------|------------------------------------------------------|-----------------------------------------------|
| Task Runner     | [Task](https://taskfile.dev/)                        | Make, just, shell scripts                     |
| HTTP Client     | curl                                                 | wget, HTTPie, Go/Python clients               |
| JSON Formatter  | jq                                                   | Python json.tool, JavaScript                  |
| Validator       | [integratify](https://github.com/zinrai/integratify) | Python scripts, Go validators, jq expressions |

## Quick Start

Start Consul cluster

```bash
$ docker compose up -d
```

Run validation

```bash
$ task
```

Clean up

```bash
$ docker compose down
```

## Adapting to Other Middleware

The pattern applies to any middleware with HTTP APIs:

1. Change `CONSUL_ADDR` in `Taskfile.yml` to your API endpoint
2. Write a CUE schema matching your API response structure
3. Define validation rules for your requirements

The workflow (fetch -> validate -> report) remains the same. Exit codes (0=success, 1=failure) enable CI/CD integration.

## License

This project is licensed under the [MIT License](./LICENSE).
