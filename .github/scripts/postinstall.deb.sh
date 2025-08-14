#!/bin/bash
set -e
set -x

REPO_OWNER="abgoyal"
REPO_NAME="go-template-project-rendered"

REPO_URL="https://${REPO_OWNER}.github.io/${REPO_NAME}"

KEYRING_PATH="/usr/share/keyrings/${REPO_NAME}-archive-keyring.gpg"
SOURCES_PATH="/etc/apt/sources.list.d/${REPO_NAME}.list"

echo "[INFO] Configuring repository for future updates..."

curl -fsSL "${REPO_URL}/deb/public.key" | gpg --dearmor --batch --yes -o "${KEYRING_PATH}"

# The distribution is "." and the component is "main".
echo "deb [arch=$(dpkg --print-architecture) signed-by=${KEYRING_PATH}] ${REPO_URL}/deb . main" > "${SOURCES_PATH}"

echo -e "\n[OK] Repository for '${REPO_NAME}' has been configured successfully."

