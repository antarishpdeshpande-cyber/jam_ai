#!/bin/bash
# ACE-Step-1.5 Installation Script for GCP VM
# This script sets up a GPU-enabled VM to run the ACE-Step music generation model

set -e

echo "=== ACE-Step-1.5 Installation ==="
echo "Starting installation at $(date)"

# Update system
echo "Updating system packages..."
sudo apt-get update && sudo apt-get upgrade -y

# Install Python 3.11
echo "Installing Python 3.11..."
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt-get update
sudo apt-get install -y python3.11 python3.11-venv python3.11-dev

# Install uv (modern Python package manager)
echo "Installing uv package manager..."
curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.local/bin/env

# Install CUDA (if not already installed)
if ! command -v nvidia-smi &> /dev/null; then
    echo "Installing NVIDIA CUDA drivers..."
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
    sudo dpkg -i cuda-keyring_1.1-1_all.deb
    sudo apt-get update
    sudo apt-get -y install cuda-toolkit-12-4
    echo 'export PATH=/usr/local/cuda/bin:$PATH' >> ~/.bashrc
    echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
    source ~/.bashrc
fi

# Clone ACE-Step repository
echo "Cloning ACE-Step-1.5..."
cd /opt
sudo git clone https://github.com/ACE-Step/ACE-Step-1.5.git
sudo chown -R $USER:$USER ACE-Step-1.5
cd ACE-Step-1.5

# Install dependencies
echo "Installing ACE-Step dependencies..."
uv sync

# Create systemd service
echo "Creating systemd service..."
sudo tee /etc/systemd/system/acestep.service > /dev/null <<EOF
[Unit]
Description=ACE-Step Music Generation API
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=/opt/ACE-Step-1.5
Environment="PATH=/home/$USER/.local/bin:/usr/local/cuda/bin:/usr/bin"
ExecStart=/home/$USER/.local/bin/uv run acestep-api --port 8001 --server-name 0.0.0.0 --api-key \${ACE_STEP_API_KEY}
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

echo ""
echo "=== Installation Complete ==="
echo "Next steps:"
echo "1. Set your API key: export ACE_STEP_API_KEY='your-secret-key'"
echo "2. Start the service: sudo systemctl start acestep"
echo "3. Enable auto-start: sudo systemctl enable acestep"
echo "4. Check status: sudo systemctl status acestep"
echo ""
echo "API will be available at http://YOUR_VM_IP:8001"
