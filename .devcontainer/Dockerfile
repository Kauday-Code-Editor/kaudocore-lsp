# Stage 1: The Builder Stage
# This stage contains all the tools needed to build the application.
FROM alpine:3.18 as builder

# Install system packages using apk
RUN apk update && \
    apk add --no-cache \
    build-base \
    clang \
    gcc \
    g++ \
    lldb \
    valgrind \
    cmake \
    ninja \
    curl \
    git \
    nasm \
    ca-certificates \
    unzip \
    python3 \
    py3-pip \
    bash-completion

# Install Rust using rustup
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Create a dedicated directory and build your project
WORKDIR /app
COPY . .
# Replace the following RUN command with your specific build command
# For example, for a C++ project using CMake:
# RUN cmake -S . -B build && cmake --build build
# For a Rust project:
# RUN cargo build --release

# Stage 2: The Final, Minimal Stage
# This stage contains only the application and its runtime dependencies.
# This makes the final image significantly smaller and faster to deploy.
FROM alpine:3.18

# Create a non-root user for security
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN addgroup -g $USER_GID $USERNAME && \
    adduser -u $USER_UID -G $USERNAME -s /bin/sh -D $USERNAME && \
    mkdir /app && \
    chown $USERNAME:$USERNAME /app

USER $USERNAME
WORKDIR /home/$USERNAME

# Copy the built artifacts from the builder stage
# Replace '/path/to/your/built/app' with the actual path to your application's binary or files
COPY --from=builder /app/your-app-binary /home/$USERNAME/your-app-binary
# Copy any required libraries that are not in the minimal base image
# E.g., for a C++ project that needs specific shared libraries
# COPY --from=builder /path/to/libs /path/to/libs

# Set the command to run the final application
CMD ["/home/vscode/your-app-binary"]
