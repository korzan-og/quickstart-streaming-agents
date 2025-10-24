#!/bin/bash

# Streaming Agents Workshop - Dependency Installation Script
# This script installs all necessary tools for the streaming agents workshop
# on Ubuntu/Debian systems with minimal user interaction

set -e  # Exit on any error

# Set environment variables for non-interactive installation
export DEBIAN_FRONTEND=noninteractive
export GPG_TTY=$(tty)

echo "🚀 Starting Streaming Agents Workshop dependency installation..."

# Update package lists only once at the beginning
echo "📦 Updating package lists..."
sudo apt-get update -y

# Install common dependencies first
echo "🔧 Installing common dependencies..."
sudo apt-get install -y \
    curl \
    wget \
    gnupg \
    software-properties-common \
    python3-pip \
    jq \
    librdkafka-dev \
    unzip \
    pkg-config

# =============================================================================
# Install UV (Python package manager)
# =============================================================================
echo "🐍 Installing UV..."
curl -LsSf https://astral.sh/uv/install.sh | sh

# Create symlink for UV (as noted in requirements)
echo "🔗 Creating UV symlink..."
if [ -f "$HOME/.cargo/bin/uv" ]; then
    sudo ln -sf "$HOME/.cargo/bin/uv" /usr/local/bin/uv
    echo "✓ UV symlink created successfully"
else
    echo "⚠️  UV binary not found at expected location"
fi

# Add to PATH for current session
export PATH="$HOME/.cargo/bin:$PATH"

# Verify UV is accessible
if command -v uv >/dev/null 2>&1; then
    echo "✓ UV is accessible"
else
    echo "⚠️  UV not found in PATH, trying alternative location..."
    # Try alternative installation location
    if [ -f "$HOME/.local/bin/uv" ]; then
        sudo ln -sf "$HOME/.local/bin/uv" /usr/local/bin/uv
        export PATH="$HOME/.local/bin:$PATH"
        echo "✓ UV found in alternative location"
    fi
fi

# =============================================================================
# Install Terraform
# =============================================================================
echo "🏗️  Installing Terraform..."

# Add HashiCorp GPG key
wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

# Add HashiCorp repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null

# Install Terraform
sudo apt-get update -y
sudo apt-get install -y terraform

# =============================================================================
# Install AWS CLI
# =============================================================================
echo "☁️  Installing AWS CLI..."

# Download and install AWS CLI v2 (recommended method)
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
yes | sudo ./aws/install --update
rm -rf aws awscliv2.zip

# =============================================================================
# Install Confluent CLI
# =============================================================================
echo "🔄 Installing Confluent CLI..."

# Add Confluent GPG key (with non-interactive flags)
sudo mkdir -p /etc/apt/keyrings
curl https://packages.confluent.io/confluent-cli/deb/archive.key | \
    sudo gpg --batch --yes --dearmor -o /etc/apt/keyrings/confluent-cli.gpg
sudo chmod go+r /etc/apt/keyrings/confluent-cli.gpg

# Add Confluent repository
echo "deb [signed-by=/etc/apt/keyrings/confluent-cli.gpg] https://packages.confluent.io/confluent-cli/deb stable main" | \
    sudo tee /etc/apt/sources.list.d/confluent-cli.list > /dev/null

# Install Confluent CLI
sudo apt-get update -y
sudo apt-get install -y confluent-cli

# =============================================================================
# Install Docker
# =============================================================================
echo "🐳 Installing Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
rm get-docker.sh

# Add current user to docker group
sudo groupadd docker 2>/dev/null || true
sudo usermod -aG docker $USER

# =============================================================================
# Install Python dependencies
# =============================================================================
echo "🐍 Installing Python dependencies..."

# Install the project in development mode
if [ -f "pyproject.toml" ]; then
    echo "📦 Installing project dependencies with UV..."
    uv sync
    echo "🔧 Installing project in development mode..."
    uv run pip install -e .
else
    echo "⚠️  pyproject.toml not found. Skipping project installation."
fi

# =============================================================================
# Verify installations
# =============================================================================
echo "✅ Verifying installations..."

echo "Checking UV..."
if command -v uv >/dev/null 2>&1; then
    uv --version
else
    echo "❌ UV installation failed - trying to fix..."
    # Try to source the shell profile to get UV in PATH
    source ~/.bashrc 2>/dev/null || true
    source ~/.profile 2>/dev/null || true
    if command -v uv >/dev/null 2>&1; then
        uv --version
    else
        echo "❌ UV still not found after PATH refresh"
    fi
fi

echo "Checking Terraform..."
terraform --version || echo "❌ Terraform installation failed"

echo "Checking AWS CLI..."
aws --version || echo "❌ AWS CLI installation failed"

echo "Checking Confluent CLI..."
confluent version || echo "❌ Confluent CLI installation failed"

echo "Checking Docker..."
docker --version || echo "❌ Docker installation failed"

echo "Checking Python/pip..."
python3 --version || echo "❌ Python3 installation failed"
pip3 --version || echo "❌ pip3 installation failed"

echo "Checking jq..."
jq --version || echo "❌ jq installation failed"

echo "Checking librdkafka..."
pkg-config --modversion rdkafka || echo "❌ librdkafka installation failed"

# =============================================================================
# Copy terraform.tfvars to required directories
# =============================================================================
echo "📁 Copying terraform.tfvars to required directories..."

if [ -f "terraform.tfvars" ]; then
    echo "Copying terraform.tfvars to aws/core/"
    cp terraform.tfvars aws/core/ 2>/dev/null || echo "⚠️  aws/core/ directory not found"
    
    echo "Copying terraform.tfvars to aws/lab1-tool-calling/"
    cp terraform.tfvars aws/lab1-tool-calling/ 2>/dev/null || echo "⚠️  aws/lab1-tool-calling/ directory not found"
    
    echo "Copying terraform.tfvars to aws/lab2-vector-search/"
    cp terraform.tfvars aws/lab2-vector-search/ 2>/dev/null || echo "⚠️  aws/lab2-vector-search/ directory not found"
    
    echo "✓ terraform.tfvars copied to all required directories"
else
    echo "⚠️  terraform.tfvars not found in current directory"
    echo "   Please ensure terraform.tfvars exists before running Terraform commands"
fi

newgrp docker

# =============================================================================
# Final setup instructions
# =============================================================================
echo ""
echo "🎉 Installation completed!"
echo ""
echo "📋 Next steps:"
echo "1. Log out and log back in (or run 'newgrp docker') to use Docker without sudo"
echo "⚠️  Important notes:"
echo "- UV has been symlinked to /usr/local/bin/uv"
echo "- You may need to restart your shell or run 'source ~/.bashrc'"
echo "- Docker group membership will be active after logout/login"
echo "- terraform.tfvars has been copied to all required directories"
echo ""
