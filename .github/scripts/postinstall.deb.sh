#!/bin/bash
set -e
REPO_OWNER="abgoyal"
REPO_NAME="multiprof"
GPG_KEY_URL="https://${REPO_OWNER}.github.io/${REPO_NAME}/deb/public.key"
SOURCES_LIST_URL="https://${REPO_OWNER}.github.io/${REPO_NAME}/deb"
KEYRING_PATH="/usr/share/keyrings/${REPO_NAME}-archive-keyring.gpg"
SOURCES_PATH="/etc/apt/sources.list.d/${REPO_NAME}.list"
echo "[INFO] Configuring repository for future updates..."
curl -fsSL "${GPG_KEY_URL}" | gpg --dearmor -o "${KEYRING_PATH}"
echo "deb [arch=amd64,arm64 signed-by=${KEYRING_PATH}] ${SOURCES_LIST_URL} ./" > "${SOURCES_PATH}"
echo -e "\n[OK] Repository for '${REPO_NAME}' has been configured successfully."

