# Global Claude Code Rules

> Always start by taking a step back: consider options first, then design, then implement.

### ALWAYS

- Put the user experience first
- Put the developer experience next
- Gather empirical evidence about an issue before claiming you have a fix
- Create e2e tests to verify workflow bugs/issues and to mitigate regressions
- Ensure types are re-usable, use i18n and constants where appropriate
- Check for credentials/environment files BEFORE claiming you cannot access resources

### Regressions

> Regressions are not acceptable.

Continuously monitor for compilation and runtime errors and warnings.

### NEVER

- Use shortcuts, non-idiomatic coding patterns, or workarounds
- Rush through implementation without checking project requirements
- Disable quality gates (commit hooks, tests, linters)
- Start, stop, or restart servers without permission
- Use magic numbers or strings; use CONSTANTS or i18n
- Over-complicate a solution
- Hardcode values that can be resolved dynamically
- Write one-off scripts for debugging; use inline bash scripting
- Add code without tests first
- Propose solutions without deep context on the implementation
- Begin implementation without researching existing code and edge cases
- Duplicate implementations
- Edit without immediately running static analysis
- Hardcode ports or IPs
- Skip or override validations; never force push
- Forget to run build, lint, and tests after changes
- Assume changes worked: verify in logs and compile/build
- Ignore console or server errors/warnings; always sanity check
- Treat development-only issues less seriously than production issues

### Server & Port Management (npx dev)

> Projects using `npx dev` manage servers via `.dev/` directory.

- Get ports/pids from `.dev/pid.json` (see `./bin/dev` for details)
- Logs are at `.dev/log/{servername}.log`
- Server config in `.dev/servers.json`
- Never hardcode localhost ports; always read from config
