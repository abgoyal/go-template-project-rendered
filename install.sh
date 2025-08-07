#!/bin/bash
set -e

# Universal installer for multiprof
# Usage: curl -sfL https://raw.githubusercontent.com/abgoyal/multiprof/main/install.sh | sh

# --- CONFIGURATION (CUSTOMIZED BY setup.sh) ---
REPO="abgoyal/multiprof"
BINARY_NAME="multiprof"
INSTALL_DIR="/usr/local/bin"

# --- HELPER FUNCTIONS ---
info() { echo "[INFO] $1"; }
error() { echo "[ERROR] $1" >&2; exit 1; }

# --- OS & ARCH DETECTION ---
setup_arch_and_os() {
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')
    ARCH=$(uname -m)
    case $OS in
        linux) OS='linux' ;;
        darwin) OS='darwin' ;;
        *) error "OS '$OS' not supported." ;;
    esac
    case $ARCH in
        x86_64) ARCH='amd64' ;;
        arm64 | aarch64) ARCH='arm64' ;;
        *) error "Architecture '$ARCH' not supported." ;;
    esac
}

# --- MAIN EXECUTION ---
info "Starting installation of $BINARY_NAME..."
setup_arch_and_os

info "Detected OS: $OS, Arch: $ARCH"

LATEST_RELEASE_URL="https://api.github.com/repos/$REPO/releases/latest"
info "Fetching latest release from GitHub..."

DOWNLOAD_URL=$(curl -s $LATEST_RELEASE_URL | grep "browser_download_url" | grep "${BINARY_NAME}_${OS}_${ARCH}" | cut -d '"' -f 4)

if [ -z "$DOWNLOAD_URL" ]; then
    error "Could not find a download URL for your system ($OS/$ARCH). Please install manually from https://github.com/$REPO/releases"
fi

TMP_FILE=$(mktemp)
trap 'rm -f "$TMP_FILE"' EXIT

info "Downloading from $DOWNLOAD_URL..."
curl -L --progress-bar "$DOWNLOAD_URL" -o "$TMP_FILE"

info "Installing binary to $INSTALL_DIR..."
chmod +x "$TMP_FILE"

if [ -w "$INSTALL_DIR" ]; then
    mv "$TMP_FILE" "$INSTALL_DIR/$BINARY_NAME"
else
    info "Write permissions needed for $INSTALL_DIR. Using sudo."
    sudo mv "$TMP_FILE" "$INSTALL_DIR/$BINARY_NAME"
fi

info "$BINARY_NAME installed successfully!"
info "Run '$BINARY_NAME --version' to test."

