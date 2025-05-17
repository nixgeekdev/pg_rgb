#!/bin/bash

# This script is intended to be run inside a Docker container to build the extension.
set -e

cd /app

# Build the extension
rm -f src/rgb.so src/rgb.o src/rgb.bc
rm -f /usr/share/postgresql/17/extension/rgb.control
rm -f /usr/share/postgresql/17/extension/rgb--0.0.1.sql
rm -f /usr/lib/postgresql/17/lib/rgb.so

make

sleep 1

# Install the extension
cp rgb.control /usr/share/postgresql/17/extension/
cp sql/rgb--0.0.1.sql /usr/share/postgresql/17/extension/
cp src/rgb.so /usr/lib/postgresql/17/lib/
