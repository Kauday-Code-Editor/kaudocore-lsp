# Kaudo LSP

- rust-lsp (Rust): delegates to rust-analyzer
- c-lsp (C): delegates to clangd
- asm-lsp (Assembly): delegates to asm-lsp

See subdirectories for build instructions.

## The Fastest Best Practices

- Pin versions: use distro packages or specific releases of rust-analyzer/clangd/asm-lsp to avoid drift.
- Prefer stdio transport: avoid TCP unless debugging; stdio minimizes latency and surprises.
- Isolate per-project state: run servers with project roots and clean env to avoid cross-project cache bleed.
- Limit logs in production: pass quiet flags (`--log=error`) to reduce I/O overhead and noise.
- Resource caps: ensure ulimits and process priorities are sane on CI and dev machines.
- Health checks: treat non-zero exit from the upstream servers as actionable; surface clear errors.
- Zero-copy stdin/stdout: launchers inherit stdio; do not buffer or transform streams.
- Keep launchers tiny: no feature logic here—delegate features to the upstream servers.
- Crash resilience: rely on the editor to restart on exit; keep launcher exit codes accurate.
- Reproducible builds: Rust—`cargo build --release`; C—`make`; NASM—`make` with pinned tools.
