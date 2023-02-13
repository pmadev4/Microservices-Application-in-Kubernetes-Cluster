#!/bin/bash

# Download the latest release
curl -LO https://github.com/roboll/helmfile/releases/download/v0.144.0/helmfile_linux_amd64

# Rename the file
mv helmfile_linux_amd64 helmfile

# Move the binary to a directory in PATH
sudo mv ./helmfile /usr/local/bin/

# Make the binary executable
sudo chmod +x /usr/local/bin/helmfile

# Verify the installation
helmfile version

