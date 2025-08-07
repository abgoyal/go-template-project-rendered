# multiprof

multiple profiles dir manager

This project is a Go application set up with a fully automated release pipeline using a reusable workflow.

## Getting Started

1.  **Use This Template:** Click the "Use this template" button on GitHub to create your own repository from this one.

2.  **Run the Setup Script:** Clone your new repository and run the setup script. This will customize all files for your project.
    ```bash
    ./setup.sh
    ```

3.  **Generate GPG Keys:** The release pipeline requires GPG keys to sign packages. You can generate them manually, or use a helper script like the one found in the `go-release-pipeline` repository.

4.  **Add GitHub Secrets:** Go to your new repository's **Settings > Secrets and variables > Actions** and add the required GPG keys and passphrases as secrets (e.g., `DEB_GPG_PRIVATE_KEY`, `DEB_GPG_PASSPHRASE`, etc.) for each package format you wish to build.

5.  **Review and Commit:** Review the changes made by the setup script. Once you are satisfied, **delete the `setup.sh` script** and commit your customized files.

6.  **Push Your First Tag:** Push a tag to trigger the release workflow.
    ```bash
    git tag v0.1.0
    git push origin v0.1.0
    ```

