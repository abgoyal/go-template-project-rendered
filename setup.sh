#!/bin/bash
set -e

echo "--- Go Project Release Pipeline Setup ---"
# --- Gather User Input ---
read -p "Enter your project name (e.g., my-cool-tool): " project_name
read -p "Enter your Go module path (e.g., github.com/your-username/my-cool-tool): " module_path
read -p "Enter a short project description: " description
read -p "Enter your name for maintainer/vendor fields: " maintainer_name
read -p "Enter your email for maintainer field: " maintainer_email
read -p "Enter your GitHub username (for URLs): " github_username

echo "" && echo "--- Configuration ---" && echo "Project Name:    $project_name" && echo "Module Path:     $module_path" && echo "Description:     $description" && echo "Maintainer:      $maintainer_name <$maintainer_email>" && echo "GitHub Username: $github_username" && echo "---------------------"
read -p "Is this correct? (y/n) " -n 1 -r && echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then echo "Setup cancelled."; exit 1; fi

# --- File Customization using sed ---
echo "[INFO] Customizing project files..."

sed -i.bak "s|__MODULE_PATH__|${module_path}|g" go.mod
sed -i.bak "s|__PROJECT_NAME__|${project_name}|g" .goreleaser.yml
sed -i.bak "s|__DESCRIPTION__|${description}|g" .goreleaser.yml
sed -i.bak "s|__MAINTAINER_NAME__|${maintainer_name}|g" .goreleaser.yml
sed -i.bak "s|__MAINTAINER_EMAIL__|${maintainer_email}|g" .goreleaser.yml
sed -i.bak "s|__GITHUB_USERNAME__|${github_username}|g" .goreleaser.yml
sed -i.bak "s|__GITHUB_USERNAME__|${github_username}|g" .github/scripts/postinstall.deb.sh
sed -i.bak "s|__PROJECT_NAME__|${project_name}|g" .github/scripts/postinstall.deb.sh
sed -i.bak "s|__GITHUB_USERNAME__|${github_username}|g" .github/scripts/postinstall.rpm.sh
sed -i.bak "s|__PROJECT_NAME__|${project_name}|g" .github/scripts/postinstall.rpm.sh
sed -i.bak "s|__PROJECT_NAME__|${project_name}|g" README.md
sed -i.bak "s|__DESCRIPTION__|${description}|g" README.md
sed -i.bak "s|__GITHUB_USERNAME__|${github_username}|g" install.sh
sed -i.bak "s|__PROJECT_NAME__|${project_name}|g" install.sh
sed -i.bak "s|__PROJECT_NAME__|${project_name}|g" main.go

find . -name "*.bak" -type f -delete

echo "" && echo "[OK] Setup complete!" && echo ""
echo "Next steps:"
echo "1. Review the generated files for correctness."
echo "2. Use the '.github/helpers/generate_gpg_key.sh' script to create your GPG keys."
echo "3. Add the private keys and passphrases as GitHub Actions secrets."
echo "4. Once you are satisfied, delete this 'setup.sh' script and the '.github/helpers' directory before committing."
echo "5. Commit the changes and push your first tag (e.g., git tag v0.1.0)."

