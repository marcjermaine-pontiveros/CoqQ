# CoqQ: Quantum Formalization with Rocq Prover 9.0

[![Rocq](https://img.shields.io/badge/Rocq-9.0.0-blue)](https://rocq-prover.org/)
[![Docker](https://img.shields.io/badge/Docker-Compose-brightgreen)](https://docs.docker.com/compose/)
[![License](https://img.shields.io/badge/License-CeCILL--B-green)](./LICENSE)

A comprehensive quantum formalization project using **The Rocq Prover 9.0** (formerly Coq) with Mathematical Components. This project provides a reproducible development environment with web-based IDEs for quantum computing research and formal verification.

## 🚀 Quick Start

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/install/)
- Git

### Launch the Environment

```bash
# Clone the repository
git clone https://github.com/coq-quantum/CoqQ.git
cd CoqQ

# Start the complete development environment
docker-compose up -d

# Access the web interface
open http://localhost
```

## 🌐 Web Interface

The system provides a unified web interface accessible at `http://localhost` with three main services:

### 🖥️ Web IDE (VS Code in Browser)
- **URL**: http://localhost/ide/
- **Password**: `rocq-dev-password`
- Full VS Code experience with Rocq language support
- Integrated terminal and file management
- Real-time collaboration support

### 📊 Jupyter Lab
- **URL**: http://localhost/jupyter/
- Interactive notebooks with OCaml/Rocq kernel
- Perfect for exploratory development and tutorials
- No authentication required (development only)

### 📚 Documentation
- **URL**: http://localhost/docs/
- Auto-generated HTML documentation
- Browse project structure and proofs

## 🏗️ Architecture

The system consists of multiple Docker services:

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   nginx (80)    │    │  Web IDE (8443) │    │ Jupyter (8888)  │
│   Reverse Proxy │ ←→ │   VS Code       │    │   Notebooks     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         ↓                        ↓                        ↓
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  rocq-dev       │    │   rocq-build    │    │   rocq-docs     │
│  Main Container │    │  Build Service  │    │ Doc Generator   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 📦 Services

### Core Development (`rocq-dev`)
- **Rocq Prover 9.0.0** with full stdlib
- Mathematical Components library
- Dune build system
- Interactive development environment

### Web IDE (`web-ide`)
- Code Server (VS Code in browser)
- Rocq language extensions
- Integrated debugging support

### Interactive Computing (`jupyter`)
- Jupyter Lab with OCaml kernel
- Rocq integration for interactive proofs
- Notebook-based tutorials

### Documentation (`docs`)
- Automated documentation generation
- HTML output with cross-references
- Project structure visualization

### Reverse Proxy (`nginx`)
- Unified access point
- Load balancing
- SSL termination ready

## 🛠️ Development Workflow

### Using the Web IDE
1. Navigate to http://localhost/ide/
2. Enter password: `rocq-dev-password`
3. Open `.v` files and start developing
4. Use integrated terminal for building: `dune build`

### Using Jupyter Notebooks
1. Go to http://localhost/jupyter/
2. Create a new notebook with OCaml kernel
3. Write and execute Rocq code interactively
4. Save notebooks in the `/notebooks` directory

### Command Line Access
```bash
# Access the main development container
docker exec -it rocq-dev bash

# Build the project
dune build

# Run specific proofs
rocq compile src/quantum.v

# Generate documentation
rocq doc --html -d docs .
```

## 📁 Project Structure

```
.
├── src/                    # Rocq source files
│   ├── quantum.v          # Main quantum formalization
│   ├── qtype.v           # Quantum types
│   ├── qreg.v            # Quantum registers
│   └── ...
├── docker-compose.yml     # Service orchestration
├── Dockerfile             # Main Rocq environment
├── Dockerfile.jupyter     # Jupyter-enabled image
├── nginx.conf             # Reverse proxy config
├── rocq-mathcomp-quantum.opam  # Package dependencies
└── README.md              # This file
```

## 🔧 Configuration

### Environment Variables

```bash
# Web IDE password
WEB_IDE_PASSWORD=rocq-dev-password

# Jupyter configuration
JUPYTER_ENABLE_LAB=yes
JUPYTER_TOKEN=""

# Rocq environment
OPAM_SWITCH_PREFIX=/home/opam/.opam/default
```

### Volume Mounts

- **Source Code**: `./:/home/opam/coqq` (read-write)
- **OPAM Cache**: `opam_cache:/home/opam/.opam` (persistent)
- **VS Code Data**: `vscode_data:/home/opam/.vscode-server` (persistent)
- **Jupyter Data**: `jupyter_data:/home/opam/.jupyter` (persistent)

## 🧪 Testing and Building

### Automated Testing
```bash
# Run all tests
docker-compose exec rocq-dev dune runtest

# Build specific targets
docker-compose exec rocq-dev dune build src/quantum.vo

# Check proofs
docker-compose exec rocq-dev rocq compile src/quantum.v
```

### Manual Verification
```bash
# Interactive proof checking
docker-compose exec rocq-dev rocq repl
Rocq < Require Import quantum.
Rocq < Check some_theorem.
```

## 📖 Dependencies

The project uses **Rocq Prover 9.0.0** with the following key dependencies:

### Core Components
- `rocq-prover.9.0.0` - The Rocq Prover
- `rocq-stdlib.9.0.0` - Standard library
- `rocq-core.9.0.0` - Core components

### Mathematical Components
- `coq-mathcomp-ssreflect` - SSReflect proof language
- `coq-mathcomp-algebra` - Algebraic structures
- `coq-mathcomp-analysis` - Mathematical analysis
- `coq-mathcomp-finmap` - Finite maps

*Note: Some MathComp packages are in transition to Rocq compatibility. The system uses the latest compatible versions.*

## 🚧 Migration from Coq

This project has been migrated from Coq 8.18.0 to Rocq 9.0.0. Key changes:

1. **Binary names**: `coq` → `rocq`
2. **Package names**: Updated opam dependencies
3. **Compatibility**: Backward compatible with existing `.v` files
4. **New features**: Enhanced LSP support, improved performance

### Legacy Support
The system maintains compatibility with existing Coq workflows while providing new Rocq features.

## 🤝 Contributing

1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feature/amazing-proof`
3. **Develop** using the web IDE or local tools
4. **Test** your changes: `docker-compose exec rocq-dev dune runtest`
5. **Submit** a pull request

### Development Guidelines
- Follow Mathematical Components style
- Document all major theorems
- Include tests for new functionality
- Use meaningful commit messages

## 📚 Learning Resources

### Rocq Prover
- [Official Documentation](https://rocq-prover.org/doc/V9.0.0/refman/)
- [Installation Guide](https://rocq-prover.org/install)
- [Migration Guide](https://rocq-prover.org/doc/V9.0.0/refman/history-and-recent-changes.html#version-9-0)

### Mathematical Components
- [Mathematical Components Book](https://math-comp.github.io/mcb/)
- [SSReflect Tutorial](https://math-comp.github.io/htmldoc/)

### Quantum Computing
- [Quantum Information Theory in Coq](link-to-papers)
- Project-specific documentation in `/docs`

## 🐛 Troubleshooting

### Common Issues

**Service won't start**
```bash
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

**Web IDE connection issues**
```bash
# Check logs
docker-compose logs web-ide

# Restart service
docker-compose restart web-ide
```

**Build failures**
```bash
# Clean build
docker-compose exec rocq-dev dune clean
docker-compose exec rocq-dev dune build
```

**Package conflicts**
```bash
# Update opam
docker-compose exec rocq-dev opam update
docker-compose exec rocq-dev opam upgrade
```

## 📄 License

This project is licensed under the CeCILL-B License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **The Rocq Development Team** for the excellent theorem prover
- **Mathematical Components Team** for the foundational libraries
- **CoqQ Contributors** for quantum formalization work
- **Docker Community** for containerization tools

---

**Happy Formal Verification! 🎯**

For questions and support, please open an issue or contact the maintainers.
