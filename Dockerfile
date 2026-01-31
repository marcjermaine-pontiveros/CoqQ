# Use OCaml base image with OPAM
FROM ocaml/opam:debian-12-ocaml-4.14

# Set working directory
WORKDIR /home/opam/coqq

# Switch to root to install system dependencies
USER root

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    wget \
    m4 \
    pkg-config \
    libgmp-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Switch back to opam user
USER opam

# Initialize opam and update
RUN opam init --disable-sandboxing -y && opam update

# Add the updated Rocq repository
RUN opam repo add rocq-released https://rocq-prover.org/opam/released

# Add the default repositories (ensuring compatibility)
RUN opam repo add default https://opam.ocaml.org || true
RUN opam repo add coq-released https://coq.inria.fr/opam/released || true

# Copy the opam file first for better Docker layer caching
COPY --chown=opam:opam coq-mathcomp-quantum.opam ./

# Install dependencies with exact versions from opam file
RUN eval $(opam env) && \
    opam install -y --deps-only . && \
    opam clean

# Copy the rest of the project
COPY --chown=opam:opam . .

# Set up the environment and build the project
RUN eval $(opam env) && opam config exec -- dune build

# Switch to root to create vscode user and install additional tools
USER root

# Create vscode user for VS Code Server compatibility
RUN useradd -m -s /bin/bash vscode && \
    usermod -aG sudo vscode && \
    echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/vscode

# Install additional development tools useful for VS Code
RUN apt-get update && apt-get install -y \
    git-core \
    openssh-client \
    openssh-server \
    sudo \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy built artifacts to make them accessible
RUN mkdir -p /home/vscode/coqq && \
    cp -r /home/opam/coqq/* /home/vscode/coqq/ 2>/dev/null || true && \
    cp -r /home/opam/.opam /home/vscode/.opam && \
    chown -R vscode:vscode /home/vscode

# Switch back to opam for setting up OPAM environment
USER opam

# Configure opam profile for all users
RUN opam env >> /home/opam/.bashrc && \
    eval $(opam env)

# Copy opam env to vscode user
USER root
RUN eval $(opam env --switch=/home/opam/.opam/default) && \
    echo 'eval $(opam env --switch=/home/opam/.opam/default)' >> /home/vscode/.bashrc && \
    chown vscode:vscode /home/vscode/.bashrc

USER vscode

# Default command
CMD ["bash"]

# Add labels for documentation
LABEL maintainer="CoqQ Development Team"
LABEL description="Docker image for CoqQ quantum formalization project"
LABEL version="1.0"