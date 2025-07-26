# Use OCaml base image with OPAM
FROM ocaml/opam:debian-12-ocaml-4.14

# Set working directory
WORKDIR /home/opam/coqq

# Switch to root to install system dependencies
USER root

# Install system dependencies including tools for web IDE
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    wget \
    m4 \
    pkg-config \
    libgmp-dev \
    nodejs \
    npm \
    python3 \
    python3-pip \
    supervisor \
    nginx \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Switch back to opam user
USER opam

# Initialize opam and update
RUN opam init --disable-sandboxing -y && opam update

# Add the Rocq repository
RUN opam repo add rocq-released https://rocq-prover.org/opam/released

# Add the default repositories (ensuring compatibility)
RUN opam repo add default https://opam.ocaml.org || true
RUN opam repo add coq-released https://coq.inria.fr/opam/released || true

# Install Rocq 9.0.0 and related tools
RUN eval $(opam env) && \
    opam install -y rocq-prover.9.0.0 rocq-stdlib dune && \
    opam clean

# Copy the opam file first for better Docker layer caching
COPY --chown=opam:opam coq-mathcomp-quantum.opam ./

# Install dependencies with exact versions from opam file
RUN eval $(opam env) && \
    opam install -y --deps-only . && \
    opam clean

# Copy the rest of the project
COPY --chown=opam:opam . .

# Set up the environment and build project
RUN eval $(opam env) && opam config exec -- dune build

# Expose ports for web IDE and development
EXPOSE 8080 3000

# Add labels for documentation
LABEL maintainer="CoqQ Development Team"
LABEL description="Docker image for CoqQ quantum formalization project with Rocq 9.0.0"
LABEL version="2.0"

# Default command
CMD ["bash", "-c", "eval $(opam env) && bash"]