## **Integrating with an Existing Project**

If you cannot use the template repository, follow these steps to manually integrate the release pipeline.

1.  **Copy the Reusable Workflow:**

      * Create a `.github/workflows/release.yml` file in your project.
      * Copy the contents from the template's `release.yml` file.
      * **Important:** Change the `uses:` line to point to the correct `go-release-pipeline` repository (`uses: owner/repo/.github/workflows/pipeline.yml@main`).

2.  **Copy Configuration Files:**

      * Copy the `.goreleaser.yml` file from the template project to the root of your repository.
      * Copy the `install.sh` script to the root of your repository and make it executable (`chmod +x install.sh`).
      * Create a `.github/scripts` directory and copy the `postinstall.deb.sh` and `postinstall.rpm.sh` files into it.

3.  **Manually Configure Files:**
    You must now manually replace all placeholders in the files you just copied. Open each file and replace the following:

      * `__PROJECT_NAME__`: Your project's binary name (e.g., `my-cool-tool`).
      * `__MODULE_PATH__`: Your project's Go module path (e.g., `github.com/you/my-cool-tool`).
      * `__DESCRIPTION__`: A short description of your project.
      * `__MAINTAINER_NAME__`: Your name.
      * `__MAINTAINER_EMAIL__`: Your email.
      * `__GITHUB_USERNAME__`: Your GitHub username.

    **Files to edit:**

      * `.goreleaser.yml`
      * `install.sh`
      * `.github/scripts/postinstall.deb.sh`
      * `.github/scripts/postinstall.rpm.sh`

4.  **Set Up GPG Keys and Secrets:**

      * Generate GPG keys for each package format you intend to support (`deb`, `rpm`, `apk`). You can copy the `generate_gpg_key.sh` script from the template repository to help with this.
      * Go to your repository's **Settings \> Secrets and variables \> Actions** and create secrets for the corresponding private keys and passphrases (e.g., `DEB_GPG_PRIVATE_KEY`, `DEB_GPG_PASSPHRASE`).

5.  **Review and Commit:**

      * Carefully review all the new and modified files to ensure the configuration is correct for your project.
      * Commit all the changes to your main branch.

6.  **Release:**

      * Your project is now ready. Push a new version tag (e.g., `git tag v1.0.0 && git push origin v1.0.0`) to trigger the release pipeline.

