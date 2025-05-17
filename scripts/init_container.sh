#!/bin/bash

# This script is intended to be run inside a Docker container to set up the environment.
# expects a debian:bookworm-slim image
set -e

# Update package lists
apt-get update

# Install necessary packages
apt-get install -y \
    mg \
    curl \
    git \
    build-essential \
    postgresql-server-dev-17

# Clean up apt cache to reduce image size
apt-get clean
rm -rf /var/lib/apt/lists/*

cd /app
rm -f src/rgb.so src/rgb.o src/rgb.bc
