#!/usr/bin/env bash
set -euo pipefail

# Usage: ./generate_gpg_key.sh <key_type> "Your Name <you@example.com>"
# Example: ./generate_gpg_key.sh deb "Project DEB Maintainer <releases@example.com>"

KEY_TYPE=$1
USER_ID=$2

if [[ -z "$KEY_TYPE" || -z "$USER_ID" ]]; then
  cat <<EOF
Usage: $0 <key_type> "User Name <email>"
  <key_type> can be: deb, rpm, apk
EOF
  exit 1
fi

# Create an isolated GPG home
TMP_GNUPGHOME=$(mktemp -d)
export GNUPGHOME="$TMP_GNUPGHOME"

# Ensure cleanup of temp GNUPGHOME on exit
cleanup() {
  rm -rf "$TMP_GNUPGHOME"
}
trap cleanup EXIT

echo "[INFO] Generating 4096-bit RSA key for '$KEY_TYPE' under GNUPGHOME=$GNUPGHOME"
cat > keyparams <<EOF
Key-Type: RSA
Key-Length: 4096
Subkey-Type: RSA
Subkey-Length: 4096
Name-Real: $USER_ID
Name-Comment: $KEY_TYPE signing key
Name-Email: $(echo "$USER_ID" | grep -oE '[^<]+@.+[^>]+')
Expire-Date: 0
%no-protection
EOF

# Batch-generate the key:
gpg --batch --generate-key keyparams

# Retrieve the newest (by creation time) primary key ID:
KEY_ID=$(
  gpg --with-colons --list-secret-keys "$USER_ID" \
    | awk -F: '/^sec:/ { print $6, $5 }' \
    | sort -nr             \
    | head -n1             \
    | cut -d' ' -f2
)

echo "[OK] Key generated: $KEY_ID"

# Export armored keys to cwd
PUBFILE="${KEY_TYPE}_public.key"
PRVFILE="${KEY_TYPE}_private.key"

echo "[INFO] Exporting public key → $PUBFILE"
gpg --armor --export "$KEY_ID" > "$PUBFILE"

echo "[INFO] Exporting private key → $PRVFILE"
gpg --armor --export-secret-keys "$KEY_ID" > "$PRVFILE"

# Remove param file
rm -f keyparams

cat <<EOF

[INFO] Done! Files in $(pwd):
   • $PUBFILE
   • $PRVFILE

--- GitHub Secret Instructions ---
Go to your repo’s Settings → Secrets and variables → Actions:
1. Create a secret named '$(echo "$KEY_TYPE" | tr 'a-z' 'A-Z')_GPG_PRIVATE_KEY' with the contents of $PRVFILE
2. Create a secret named '$(echo "$KEY_TYPE" | tr 'a-z' 'A-Z')_GPG_PASSPHRASE' (if you add one later)
EOF
