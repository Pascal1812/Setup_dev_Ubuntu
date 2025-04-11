#!/bin/bash

# Ubuntu Development Environment Setup Script

# Exit on any error
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print status messages
print_status() {
    echo -e "${GREEN}[*] $1${NC}"
}

# Function to print error messages
print_error() {
    echo -e "${RED}[ERROR] $1${NC}"
}

# Function to print warning messages
print_warning() {
    echo -e "${YELLOW}[WARNING] $1${NC}"
}

# Check if script is run as root
if [ "$EUID" -eq 0 ]; then 
    print_error "Please do not run as root or with sudo"
    exit 1
fi

# Check Ubuntu version
if ! grep -q "Ubuntu" /etc/os-release; then
    print_error "This script is designed for Ubuntu only"
    exit 1
fi

# Create a log file
LOG_FILE="$HOME/dev_setup_$(date +%Y%m%d_%H%M%S).log"
exec 1> >(tee -a "$LOG_FILE")
exec 2>&1

print_status "Starting development environment setup..."

# Update and Upgrade System
print_status "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install basic dependencies
print_status "Installing basic dependencies..."
sudo apt install -y \
    curl \
    wget \
    git \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    build-essential \
    unzip \
    || { print_error "Failed to install basic dependencies"; exit 1; }

# Install Visual Studio Code
print_status "Installing Visual Studio Code..."
if ! command -v code &> /dev/null; then
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/packages.microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt update
    sudo apt install -y code
    rm -f packages.microsoft.gpg
else
    print_warning "VS Code is already installed"
fi

# Install Docker and Docker Compose
print_status "Installing Docker and Docker Compose..."
if ! command -v docker &> /dev/null; then
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    sudo usermod -aG docker $USER
    print_warning "Please log out and back in for Docker group changes to take effect"
else
    print_warning "Docker is already installed"
fi

# Install Ansible
print_status "Installing Ansible..."
if ! command -v ansible &> /dev/null; then
    sudo apt install -y ansible
else
    print_warning "Ansible is already installed"
fi

# Install VirtualBox
print_status "Installing VirtualBox..."
if ! command -v virtualbox &> /dev/null; then
    sudo apt install -y virtualbox virtualbox-ext-pack
else
    print_warning "VirtualBox is already installed"
fi

# Install Vagrant
print_status "Installing Vagrant..."
if ! command -v vagrant &> /dev/null; then
    wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
        sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update
    sudo apt install -y vagrant
else
    print_warning "Vagrant is already installed"
fi

# Install Go
print_status "Installing Go..."
GO_VERSION="1.21.0"
if ! command -v go &> /dev/null; then
    wget "https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz"
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf "go${GO_VERSION}.linux-amd64.tar.gz"
    rm "go${GO_VERSION}.linux-amd64.tar.gz"
    
    # Add Go to PATH if not already added
    if ! grep -q "/usr/local/go/bin" "$HOME/.bashrc"; then
        echo 'export PATH=$PATH:/usr/local/go/bin' >> "$HOME/.bashrc"
        echo 'export GOPATH=$HOME/go' >> "$HOME/.bashrc"
        echo 'export PATH=$PATH:$GOPATH/bin' >> "$HOME/.bashrc"
    fi
else
    print_warning "Go is already installed"
fi

# Install Node.js and npm
print_status "Installing Node.js and npm..."
if ! command -v node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt install -y nodejs
    
    # Install Yarn and Next.js globally
    sudo npm install -g yarn
    sudo npm install -g next
else
    print_warning "Node.js is already installed"
fi

# Install Java
print_status "Installing Java..."
if ! command -v java &> /dev/null; then
    sudo apt install -y default-jdk
else
    print_warning "Java is already installed"
fi

# Install Python and pip
print_status "Installing Python and pip..."
if ! command -v python3 &> /dev/null; then
    sudo apt install -y python3 python3-pip python3-venv
    sudo pip3 install --upgrade pip
    sudo pip3 install virtualenv
else
    print_warning "Python is already installed"
fi

# Final setup and verification
print_status "Installation complete! Here are the installed versions:"
echo ""
echo "VS Code: $(code --version 2>/dev/null | head -n 1 || echo 'Not found')"
echo "Docker: $(docker --version 2>/dev/null || echo 'Not found')"
echo "Docker Compose: $(docker compose version 2>/dev/null || echo 'Not found')"
echo "Ansible: $(ansible --version 2>/dev/null | head -n 1 || echo 'Not found')"
echo "VirtualBox: $(vboxmanage --version 2>/dev/null || echo 'Not found')"
echo "Vagrant: $(vagrant --version 2>/dev/null || echo 'Not found')"
echo "Go: $(go version 2>/dev/null || echo 'Not found')"
echo "Node.js: $(node --version 2>/dev/null || echo 'Not found')"
echo "npm: $(npm --version 2>/dev/null || echo 'Not found')"
echo "Java: $(java -version 2>&1 | head -n 1 || echo 'Not found')"
echo "Python: $(python3 --version 2>/dev/null || echo 'Not found')"
echo "pip: $(pip3 --version 2>/dev/null || echo 'Not found')"

print_status "Setup completed! Log file saved to: $LOG_FILE"
print_warning "Please log out and log back in for all changes to take effect."