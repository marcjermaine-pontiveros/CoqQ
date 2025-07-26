# 🚀 Getting Started with CoqQ Rocq Environment

This guide will help you set up and start using the CoqQ Rocq development environment in just a few minutes.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) (version 20.10+)
- [Docker Compose](https://docs.docker.com/compose/install/) (either `docker-compose` or `docker compose`)

## Quick Start (3 Steps)

### 1. **Clone and Setup**

```bash
# If you haven't already cloned the repository
git clone <your-repository-url>
cd CoqQ

# Quick setup with our automated script
./start.sh
```

### 2. **Or use Make commands**

```bash
# Complete setup
make setup

# Or start step-by-step
make start
```

### 3. **Access the Environment**

- **🌐 Main Dashboard**: http://localhost
- **🖥️ Web IDE**: http://localhost/ide/ (password: `rocq-dev-password`)
- **📊 Jupyter Lab**: http://localhost/jupyter/
- **📚 Documentation**: http://localhost/docs/

## What You Get

✅ **Rocq Prover 9.0** - Latest theorem prover  
✅ **Web IDE** - VS Code in your browser  
✅ **Jupyter Lab** - Interactive notebooks for exploration  
✅ **Documentation** - Auto-generated project docs  
✅ **Persistent Storage** - Your work is saved between sessions  
✅ **Zero Config** - Everything pre-configured  

## First Steps in the Web IDE

1. **Open Web IDE**: Go to http://localhost/ide/
2. **Enter Password**: `rocq-dev-password`
3. **Open a file**: Try `src/quantum.v`
4. **Build project**: Use terminal: `make build`

## Common Commands

```bash
# Start the environment
make start

# Access container shell
make shell

# Build the project
make build

# Run tests
make test

# View logs
make logs

# Stop everything
make stop

# Complete cleanup
make clean-all
```

## Development Workflow

### Using the Web IDE
- Full VS Code experience in your browser
- Rocq language support with syntax highlighting
- Integrated terminal for building and testing
- File explorer and search functionality

### Using Jupyter Lab
- Interactive notebooks for exploration and documentation
- Mix code, markdown, and mathematical notation
- Perfect for learning, prototyping, and analysis
- Persistent notebooks saved between sessions

### Building and Testing
```bash
# Inside the web IDE terminal or via make:
dune build          # Build the project
dune runtest        # Run tests
rocq compile file.v # Compile specific file
```

### Accessing the Container Directly
```bash
# Get a shell in the main container
make shell

# Or with docker directly
docker exec -it rocq-dev bash
```

## Troubleshooting

### Services Won't Start
```bash
./start.sh clean     # Clean everything
./start.sh           # Restart fresh
```

### Build Issues
```bash
make clean-all       # Remove all containers and volumes
make setup           # Fresh setup
```

### Web IDE Not Accessible
- Check if services are running: `make status`
- Check logs: `make logs-ide`
- Try restarting: `make restart`

### Permission Issues
```bash
# On Linux, you might need to fix permissions
sudo chown -R $USER:$USER .
```

## Project Structure

```
CoqQ/
├── src/                 # Rocq source files (.v files)
├── docker-compose.yml   # Service configuration
├── Dockerfile           # Main container definition
├── nginx.conf           # Web interface routing
├── start.sh             # Quick start script
├── Makefile             # Development commands
└── README.md            # Full documentation
```

## Next Steps

1. **Explore the codebase**: Browse `src/` directory in the Web IDE
2. **Read the docs**: Visit http://localhost/docs/
3. **Run examples**: Try building and testing existing proofs
4. **Start developing**: Create new `.v` files and write proofs!

## Need Help?

- **Full Documentation**: See [README.md](README.md)
- **Commands**: Run `make help` for all available commands
- **Script Help**: Run `./start.sh help` for script options
- **Container Access**: Use `make shell` to debug inside the container

---

**Happy Formal Verification! 🎯**

The environment is designed to "just work" - if you encounter issues, try `make clean-all && make setup` for a fresh start.