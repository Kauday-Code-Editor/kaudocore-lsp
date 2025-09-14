#!/bin/bash
set -e

echo "Post-create script running..."

# Source rust environment
source $HOME/.cargo/env

# Update rust toolchain
rustup update

# install additional Rust components
rustup component add rust-src rustfmt clippy

echo "Seyup complete."
