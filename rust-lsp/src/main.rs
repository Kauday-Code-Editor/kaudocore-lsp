use std::env;
use std::process::{Command, Stdio};
use anyhow::{bail, Context, Result};

fn main() -> Result<()> {
    let server = env::var("KAUDO_RUST_LSP").unwrap_or_else(|_| "rust-analyzer".to_string());

    let mut args: Vec<String> = env::args().skip(1).collect();
    if !args.iter().any(|a| a == "--stdio") {
        args.insert(0, "--stdio".to_string());
    }

    let mut child = Command::new(&server)
        .args(&args)
        .stdin(Stdio::inherit())
        .stdout(Stdio::inherit())
        .stderr(Stdio::inherit())
        .spawn()
        .with_context(|| format!("failed to spawn {} (is it installed?)", server))?;

    let status = child.wait().with_context(|| "failed waiting for rust-analyzer")?;
    if status.success() {
        Ok(())
    } else if let Some(code) = status.code() {
        bail!("{} exited with status code {}", server, code)
    } else {
        bail!("{} terminated by signal", server)
    }
}
