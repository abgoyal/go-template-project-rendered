#!/bin/bash
set -e
REPO_OWNER="abgoyal"
REPO_NAME="go-template-project-rendered"
REPO_FILE_PATH="/etc/yum.repos.d/${REPO_NAME}.repo"
echo "[INFO] Configuring YUM/DNF repository for future updates..."
cat > "${REPO_FILE_PATH}" << EOF
[${REPO_NAME}]
name=${REPO_NAME} repository
baseurl=https://${REPO_OWNER}.github.io/${REPO_NAME}/rpm/\$basearch
enabled=1
gpgcheck=1
gpgkey=https://${REPO_OWNER}.github.io/${REPO_NAME}/rpm/public.key
EOF
echo -e "\n[OK] Repository for '${REPO_NAME}' has been configured successfully."
