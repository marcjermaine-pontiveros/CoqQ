#!/bin/bash

# CoqQ Rocq Development Environment Quick Start Script
# Updated for Rocq 9.0.0

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Emoji symbols
ROCKET="🚀"
CHECK="✅"
TOOLS="🔧"
COMPUTER="💻"
BOOK="📚"
WARNING="⚠️"
INFO="ℹ️"

print_header() {
    echo -e "${PURPLE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                 CoqQ Rocq Development Environment            ║"
    echo "║                    Quick Start Script                       ║"
    echo "║                                                              ║"
    echo "║                 Rocq Prover 9.0.0 + Docker                 ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_step() {
    echo -e "${CYAN}$1${NC} $2"
}

print_success() {
    echo -e "${GREEN}$CHECK${NC} $1"
}

print_info() {
    echo -e "${BLUE}$INFO${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}$WARNING${NC} $1"
}

print_error() {
    echo -e "${RED}❌${NC} $1"
}

check_requirements() {
    print_step "$TOOLS" "Checking requirements..."
    
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker first."
        echo "Visit: https://docs.docker.com/get-docker/"
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose is not installed. Please install Docker Compose first."
        echo "Visit: https://docs.docker.com/compose/install/"
        exit 1
    fi
    
    print_success "Docker and Docker Compose are available"
}

build_images() {
    print_step "$ROCKET" "Building Docker images..."
    print_info "This may take 10-15 minutes on first run..."
    
    if docker-compose build; then
        print_success "Docker images built successfully"
    else
        print_error "Failed to build Docker images"
        exit 1
    fi
}

start_services() {
    print_step "$COMPUTER" "Starting services..."
    
    if docker-compose up -d; then
        print_success "All services started successfully"
    else
        print_error "Failed to start services"
        exit 1
    fi
}

wait_for_services() {
    print_step "⏳" "Waiting for services to be ready..."
    
    # Wait for main container to be ready
    for i in {1..30}; do
        if docker-compose exec -T rocq-dev echo "ready" &> /dev/null; then
            break
        fi
        if [ $i -eq 30 ]; then
            print_warning "Services might not be fully ready yet"
            break
        fi
        sleep 2
    done
    
    print_success "Services are ready"
}

install_dependencies() {
    print_step "📦" "Installing project dependencies..."
    
    if docker-compose exec -T rocq-dev bash -c "eval \$(opam env) && opam install --deps-only -y ."; then
        print_success "Dependencies installed successfully"
    else
        print_warning "Some dependencies might have installation issues"
        print_info "You can retry with: make install-deps"
    fi
}

build_project() {
    print_step "🔨" "Building CoqQ project..."
    
    if docker-compose exec -T rocq-dev bash -c "eval \$(opam env) && dune build"; then
        print_success "Project built successfully"
    else
        print_warning "Build encountered some issues"
        print_info "You can retry with: make build"
    fi
}

show_access_info() {
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗"
    echo -e "║                    🎉 Setup Complete! 🎉                   ║"
    echo -e "╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}🌐 Web Interface:${NC}      http://localhost"
    echo -e "${CYAN}🖥️  Web IDE:${NC}           http://localhost/ide/"
    echo -e "${CYAN}🔑 IDE Password:${NC}       rocq-dev-password"
    echo -e "${CYAN}📊 Jupyter Lab:${NC}       http://localhost/jupyter/"
    echo -e "${CYAN}📚 Documentation:${NC}     http://localhost/docs/"
    echo ""
    echo -e "${YELLOW}Quick Commands:${NC}"
    echo -e "  ${BLUE}make help${NC}           - Show all available commands"
    echo -e "  ${BLUE}make shell${NC}          - Access development container"
    echo -e "  ${BLUE}make build${NC}          - Build the project"
    echo -e "  ${BLUE}make test${NC}           - Run tests"
    echo -e "  ${BLUE}make stop${NC}           - Stop all services"
    echo ""
    echo -e "${GREEN}Happy Formal Verification! 🎯${NC}"
}

show_status() {
    echo ""
    print_step "📊" "Service Status:"
    docker-compose ps
}

# Main execution
main() {
    print_header
    
    echo -e "${BLUE}This script will set up the complete CoqQ Rocq development environment.${NC}"
    echo -e "${BLUE}It includes Docker containers with Rocq 9.0.0, web IDE, and Jupyter Lab.${NC}"
    echo ""
    
    read -p "Continue with setup? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Setup cancelled by user"
        exit 0
    fi
    
    echo ""
    check_requirements
    build_images
    start_services
    wait_for_services
    install_dependencies
    build_project
    show_status
    show_access_info
}

# Handle script arguments
case "${1:-}" in
    "status")
        docker-compose ps
        ;;
    "stop")
        print_step "🛑" "Stopping all services..."
        docker-compose down
        print_success "All services stopped"
        ;;
    "restart")
        print_step "🔄" "Restarting services..."
        docker-compose restart
        print_success "Services restarted"
        show_access_info
        ;;
    "logs")
        docker-compose logs -f
        ;;
    "clean")
        print_step "🧹" "Cleaning up..."
        docker-compose down -v --remove-orphans
        docker system prune -f
        print_success "Cleanup completed"
        ;;
    "help"|"-h"|"--help")
        echo "CoqQ Rocq Development Environment Quick Start"
        echo ""
        echo "Usage: $0 [command]"
        echo ""
        echo "Commands:"
        echo "  (no args)  - Run complete setup"
        echo "  status     - Show service status"
        echo "  stop       - Stop all services"
        echo "  restart    - Restart all services"
        echo "  logs       - Show logs"
        echo "  clean      - Clean up everything"
        echo "  help       - Show this help"
        ;;
    *)
        main
        ;;
esac