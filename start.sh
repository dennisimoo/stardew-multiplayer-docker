#!/bin/bash

# Auto-detect platform for Docker
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS - use x86 emulation for compatibility
    export DOCKER_PLATFORM="linux/amd64"
    echo "Detected macOS - using linux/amd64 platform"
else
    # Linux - use native ARM64 for Ampere servers
    export DOCKER_PLATFORM="linux/arm64"
    echo "Detected Linux - using linux/arm64 platform"
fi

# Start the container
docker-compose up -d

echo "Stardew Valley web interface should be available at:"
echo "http://localhost:5801"
echo "VNC Password: nyanyanya"