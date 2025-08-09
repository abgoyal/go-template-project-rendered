#!/bin/bash
set -e
set -x

REPO_OWNER="abgoyal"
REPO_NAME="go-template-project-rendered"
# This URL will be redirected to code.abgoyal.com by GitHub Pages CNAME, which is fine.
REPO_URL="https://${REPO_OWNER}.github.io/${REPO_NAME}"

KEYRING_PATH="/usr/share/keyrings/${REPO_NAME}-archive-keyring.gpg"
SOURCES_PATH="/etc/apt/sources.list.d/${REPO_NAME}.list"

echo "[INFO] Configuring repository for future updates..."

# --- FIX 1: Make GPG non-interactive and robust ---
# Added --batch and --yes to prevent gpg from hanging.
curl -fsSL "${REPO_URL}/deb/public.key" | gpg --dearmor --batch --yes -o "${KEYRING_PATH}"

# --- FIX 2: Correct the sources.list entry ---
# The distribution is "." and the component is "main".
# This also now correctly supports both amd64 and arm64.
echo "deb [arch=$(dpkg --print-architecture) signed-by=${KEYRING_PATH}] ${REPO_URL}/deb . main" > "${SOURCES_PATH}"

echo -e "\n[OK] Repository for '${REPO_NAME}' has been configured successfully."

