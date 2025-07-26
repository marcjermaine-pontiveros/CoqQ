# CoqQ Rocq Development Makefile
# Updated for Rocq 9.0.0 with Docker Compose

.PHONY: help build start stop restart shell build-clean docs test clean logs status

# Detect docker compose command
DOCKER_COMPOSE := $(shell if command -v docker-compose >/dev/null 2>&1; then echo "docker-compose"; else echo "docker compose"; fi)

# Default target
help: ## Show this help message
	@echo "CoqQ Rocq Development Environment"
	@echo "================================="
	@echo "Available targets:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# Environment Management
start: ## Start all services
	@echo "🚀 Starting CoqQ Rocq development environment..."
	$(DOCKER_COMPOSE) up -d
	@echo "✅ Environment started!"
	@echo "📱 Web Interface: http://localhost"
	@echo "🖥️  Web IDE: http://localhost/ide/ (password: rocq-dev-password)"
	@echo "📚 Docs: http://localhost/docs/"

stop: ## Stop all services
	@echo "🛑 Stopping CoqQ Rocq development environment..."
	$(DOCKER_COMPOSE) down
	@echo "✅ Environment stopped!"

restart: ## Restart all services
	@echo "🔄 Restarting CoqQ Rocq development environment..."
	$(DOCKER_COMPOSE) restart
	@echo "✅ Environment restarted!"

# Development
build: ## Build the project using Rocq
	@echo "🔨 Building CoqQ project with Rocq..."
	$(DOCKER_COMPOSE) exec rocq-dev bash -c "eval \$$(opam env) && dune build"
	@echo "✅ Build completed!"

build-clean: ## Clean and rebuild the project
	@echo "🧹 Cleaning and rebuilding CoqQ project..."
	$(DOCKER_COMPOSE) exec rocq-dev bash -c "eval \$$(opam env) && dune clean && dune build"
	@echo "✅ Clean build completed!"

shell: ## Access the main development container
	@echo "🐚 Accessing Rocq development container..."
	$(DOCKER_COMPOSE) exec rocq-dev bash -c "eval \$$(opam env) && bash"

# Testing and Verification
test: ## Run all tests
	@echo "🧪 Running tests..."
	$(DOCKER_COMPOSE) exec rocq-dev bash -c "eval \$$(opam env) && dune runtest"
	@echo "✅ Tests completed!"

verify: ## Verify specific file (usage: make verify FILE=src/quantum.v)
	@echo "🔍 Verifying $(FILE)..."
	$(DOCKER_COMPOSE) exec rocq-dev bash -c "eval \$$(opam env) && rocq compile $(FILE)"
	@echo "✅ Verification completed!"

# Documentation
docs: ## Generate documentation
	@echo "📚 Generating documentation..."
	$(DOCKER_COMPOSE) up -d docs
	@echo "✅ Documentation generated!"
	@echo "📖 Available at: http://localhost/docs/"

docs-clean: ## Clean and regenerate documentation
	@echo "🧹 Cleaning and regenerating documentation..."
	$(DOCKER_COMPOSE) exec rocq-dev bash -c "eval \$$(opam env) && rm -rf _build/install/default/doc && dune build @doc"
	$(DOCKER_COMPOSE) restart docs
	@echo "✅ Documentation regenerated!"

# Container Management
logs: ## Show logs for all services
	$(DOCKER_COMPOSE) logs -f

logs-dev: ## Show logs for development container
	$(DOCKER_COMPOSE) logs -f rocq-dev

logs-ide: ## Show logs for web IDE
	$(DOCKER_COMPOSE) logs -f web-ide

status: ## Show status of all services
	@echo "📊 Service Status:"
	@echo "=================="
	$(DOCKER_COMPOSE) ps

# Cleanup
clean: ## Clean all build artifacts
	@echo "🧹 Cleaning build artifacts..."
	$(DOCKER_COMPOSE) exec rocq-dev bash -c "eval \$$(opam env) && dune clean"
	@echo "✅ Cleanup completed!"

clean-all: ## Stop services and remove all containers and volumes
	@echo "🗑️  Removing all containers, networks, and volumes..."
	$(DOCKER_COMPOSE) down -v --remove-orphans
	docker system prune -f
	@echo "✅ Complete cleanup done!"

# Development Shortcuts
ide: ## Open Web IDE
	@echo "🖥️  Opening Web IDE..."
	@echo "🌐 Web IDE available at: http://localhost/ide/"
	@echo "🔑 Password: rocq-dev-password"

jupyter: ## Open Jupyter Lab
	@echo "📊 Opening Jupyter Lab..."
	@echo "🌐 Jupyter available at: http://localhost/jupyter/"

web: ## Open main web interface
	@echo "🌐 Opening main web interface..."
	@echo "📱 Available at: http://localhost"

# Quick Development Commands
install-deps: ## Install/update project dependencies
	@echo "📦 Installing dependencies..."
	$(DOCKER_COMPOSE) exec rocq-dev bash -c "eval \$$(opam env) && opam install --deps-only -y ."
	@echo "✅ Dependencies installed!"

update-rocq: ## Update Rocq to latest compatible version
	@echo "⬆️  Updating Rocq..."
	$(DOCKER_COMPOSE) exec rocq-dev bash -c "eval \$$(opam env) && opam update && opam upgrade rocq-prover rocq-stdlib rocq-core"
	@echo "✅ Rocq updated!"

# File Operations
compile: ## Compile specific file (usage: make compile FILE=src/quantum.v)
	@echo "⚙️  Compiling $(FILE)..."
	$(DOCKER_COMPOSE) exec rocq-dev bash -c "eval \$$(opam env) && rocq compile $(FILE)"

check: ## Check specific file without compilation (usage: make check FILE=src/quantum.v)
	@echo "✅ Checking $(FILE)..."
	$(DOCKER_COMPOSE) exec rocq-dev bash -c "eval \$$(opam env) && rocq check $(FILE)"

# Interactive Development
repl: ## Start Rocq REPL
	@echo "🎮 Starting Rocq REPL..."
	$(DOCKER_COMPOSE) exec rocq-dev bash -c "eval \$$(opam env) && rocq repl"

# Project Information
info: ## Show project information
	@echo "ℹ️  CoqQ Project Information"
	@echo "==========================="
	@echo "🔬 Project: Quantum Formalization with Rocq"
	@echo "📦 Rocq Version: 9.0.0"
	@echo "🐳 Docker: Containerized development environment"
	@echo "🌐 Web Interface: http://localhost"
	@echo ""
	@echo "📁 Services:"
	@echo "  - rocq-dev: Main development container"
	@echo "  - web-ide: VS Code in browser (port 8443)"
	@echo "  - jupyter: Interactive notebooks (port 8888)"
	@echo "  - docs: Documentation server (port 8000)"
	@echo "  - nginx: Reverse proxy (port 80)"

# Backup and Restore
backup: ## Create backup of volumes
	@echo "💾 Creating backup..."
	docker run --rm -v coqq_opam_cache:/data -v $(PWD):/backup alpine tar czf /backup/opam_cache_backup.tar.gz -C /data .
	docker run --rm -v coqq_vscode_data:/data -v $(PWD):/backup alpine tar czf /backup/vscode_data_backup.tar.gz -C /data .
	@echo "✅ Backup created: opam_cache_backup.tar.gz, vscode_data_backup.tar.gz"

restore: ## Restore backup of volumes
	@echo "🔄 Restoring backup..."
	docker run --rm -v coqq_opam_cache:/data -v $(PWD):/backup alpine tar xzf /backup/opam_cache_backup.tar.gz -C /data
	docker run --rm -v coqq_vscode_data:/data -v $(PWD):/backup alpine tar xzf /backup/vscode_data_backup.tar.gz -C /data
	@echo "✅ Backup restored!"

# Quick start for new users
setup: ## Complete setup for new users
	@echo "🎯 Setting up CoqQ Rocq development environment..."
	@echo "1️⃣  Building containers..."
	$(DOCKER_COMPOSE) build
	@echo "2️⃣  Starting services..."
	$(DOCKER_COMPOSE) up -d
	@echo "3️⃣  Installing dependencies..."
	$(DOCKER_COMPOSE) exec rocq-dev bash -c "eval \$$(opam env) && opam install --deps-only -y ."
	@echo "4️⃣  Building project..."
	$(DOCKER_COMPOSE) exec rocq-dev bash -c "eval \$$(opam env) && dune build"
	@echo "✅ Setup completed!"
	@echo ""
	@echo "🎉 CoqQ Rocq environment is ready!"
	@echo "🌐 Web Interface: http://localhost"
	@echo "🖥️  Web IDE: http://localhost/ide/ (password: rocq-dev-password)"
	@echo "📚 Docs: http://localhost/docs/"
