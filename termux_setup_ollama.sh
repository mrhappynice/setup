#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to display messages
echo_info() {
    echo -e "\e[32m[INFO]\e[0m $1"
}

echo_error() {
    echo -e "\e[31m[ERROR]\e[0m $1"
}

# 1. Check if Go is installed
if ! command -v go >/dev/null 2>&1; then
    echo_error "Go is not installed. Please install Go using 'pkg install golang' and try again."
    exit 1
fi
echo_info "Go is installed."

# 2. Clone the ollama repository
REPO_URL="https://github.com/jmorganca/ollama.git"
CLONE_DIR="ollama"

if [ -d "$CLONE_DIR" ]; then
    echo_info "Directory '$CLONE_DIR' already exists. Pulling the latest changes."
    cd "$CLONE_DIR"
    git pull
else
    echo_info "Cloning the repository from $REPO_URL"
    git clone --depth 1 "$REPO_URL"
    cd "$CLONE_DIR"
fi

# 3. Edit line 3 of go.mod
GO_MOD_FILE="go.mod"

if [ ! -f "$GO_MOD_FILE" ]; then
    echo_error "'$GO_MOD_FILE' does not exist in the current directory."
    exit 1
fi

# Display the original line 3
echo_info "Original line 3 in $GO_MOD_FILE:"
sed -n '3p' "$GO_MOD_FILE"

# Replace '1.23.4' with '1.23.2' on line 3
sed -i '3s/1\.23\.4/1.23.2/' "$GO_MOD_FILE"

# Verify the change
echo_info "Updated line 3 in $GO_MOD_FILE:"
sed -n '3p' "$GO_MOD_FILE"

# 4. Build the project
echo_info "Building the project with 'go build .'"
go build .

echo_info "Build completed successfully."
