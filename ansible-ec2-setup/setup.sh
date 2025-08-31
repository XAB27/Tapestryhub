#!/bin/bash

# Universal Setup Script for Ansible EC2 Deployment ...
# This script works on Windows, Mac, and Linux to help users deploy to EC2

set -e

echo "🚀 Ansible EC2 Deployment Setup"
echo "================================"

# Detect operating system
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macOS"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="Linux"
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    OS="Windows"
else
    echo "❌ Unsupported operating system: $OSTYPE"
    echo "💡 This script supports macOS, Linux, and Windows (WSL/Git Bash)"
    exit 1
fi

echo "✅ Detected OS: $OS"

# Function to install Ansible on macOS
install_ansible_mac() {
    echo "🍎 Installing Ansible on macOS..."
    
    # Check if Homebrew is installed
    if ! command -v brew &> /dev/null; then
        echo "📦 Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
        elif [[ -f "/usr/local/bin/brew" ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
            echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zshrc
        fi
    fi
    
    # Install Ansible
    echo "🔧 Installing Ansible..."
    brew install ansible
    
    echo "✅ Ansible installed successfully on macOS"
}

# Function to install Ansible on Linux
install_ansible_linux() {
    echo "🐧 Installing Ansible on Linux..."
    
    # Detect Linux distribution
    if [[ -f /etc/debian_version ]]; then
        # Ubuntu/Debian
        echo "📦 Installing Ansible on Ubuntu/Debian..."
        sudo apt update
        sudo apt install -y software-properties-common
        sudo apt-add-repository --yes --update ppa:ansible/ansible
        sudo apt install -y ansible
    elif [[ -f /etc/redhat-release ]]; then
        # RHEL/CentOS/Fedora
        echo "📦 Installing Ansible on RHEL/CentOS/Fedora..."
        if command -v dnf &> /dev/null; then
            sudo dnf install -y ansible
        else
            sudo yum install -y ansible
        fi
    else
        echo "❌ Unsupported Linux distribution"
        echo "💡 Please install Ansible manually: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html"
        exit 1
    fi
    
    echo "✅ Ansible installed successfully on Linux"
}

# Function to install Ansible on Windows
install_ansible_windows() {
    echo "🪟 Installing Ansible on Windows..."
    
    echo "📝 For Windows, you have several options:"
    echo "1. Use Windows Subsystem for Linux (WSL) - Recommended"
    echo "2. Use Git Bash"
    echo "3. Use PowerShell with pip"
    echo ""
    echo "💡 Recommended: Install WSL and run this script again"
    echo "   Or use: pip install ansible"
    echo ""
    echo "🔗 WSL Installation: https://docs.microsoft.com/en-us/windows/wsl/install"
    
    # Check if WSL is available
    if command -v wsl &> /dev/null; then
        echo "✅ WSL detected. You can run this script inside WSL."
    fi
    
    exit 0
}

# Function to guide EC2 setup
guide_ec2_setup() {
    echo ""
    echo "🌐 EC2 Setup Guide:"
    echo "=================="
    echo "1. Launch an EC2 instance (Ubuntu 24.04 recommended)"
    echo "2. Get the public IP address"
    echo "3. Ensure your SSH key is accessible"
    echo "4. Update inventory/hosts.yml with your details:"
    echo ""
    echo "   ansible_host: YOUR_EC2_IP"
    echo "   ansible_user: ubuntu (or ec2-user for Amazon Linux)"
    echo "   ansible_ssh_private_key_file: ~/.ssh/YOUR_KEY.pem"
    echo ""
    echo "5. Test connection: ansible ec2-instance -m ping"
    echo "6. Run deployment: ansible-playbook playbooks/main.yml"
    echo ""
}

# Function to test Ansible installation
test_ansible() {
    echo "🧪 Testing Ansible installation..."
    
    if command -v ansible &> /dev/null; then
        echo "✅ Ansible is installed:"
        ansible --version | head -1
    else
        echo "❌ Ansible is not installed or not in PATH"
        exit 1
    fi
}

# Function to check prerequisites
check_prerequisites() {
    echo "🔍 Checking prerequisites..."
    
    # Check if inventory file exists
    if [[ ! -f "inventory/hosts.yml" ]]; then
        echo "❌ inventory/hosts.yml not found"
        echo "💡 Make sure you're running this script from the ansible-ec2-setup directory"
        exit 1
    fi
    
    # Check if playbooks exist
    if [[ ! -f "playbooks/main.yml" ]]; then
        echo "❌ playbooks/main.yml not found"
        echo "💡 Make sure you're running this script from the ansible-ec2-setup directory"
        exit 1
    fi
    
    echo "✅ Prerequisites check passed"
}

# Main execution
echo ""
echo "🎯 This script will help you deploy Docker, Jenkins, SonarQube, Trivy, Prometheus, Node Exporter, Grafana, and Kubernetes utilities to your EC2 instance"
echo "   I hope this works for you :) ."
echo ""

# Install Ansible based on OS
case "$OS" in
    "macOS")
        install_ansible_mac
        ;;
    "Linux")
        install_ansible_linux
        ;;
    "Windows")
        install_ansible_windows
        ;;
esac

# Test Ansible installation
test_ansible

# Check prerequisites
check_prerequisites

# Guide EC2 setup
guide_ec2_setup

echo ""
echo "📚 For detailed instructions, see README.md"
echo "🔧 For troubleshooting, check the troubleshooting section in README.md"
echo ""
echo "🤓 Juice4Tech! 🚀"
