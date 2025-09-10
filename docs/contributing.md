# Contributing Guidelines

Felis Shell is a personal hobby project, and I welcome contributions from the community! By contributing, you help make this dotfile collection more robust, efficient, and user-friendly for everyone. Please take a moment to review this guide to ensure a smooth and effective contribution process.

## 🤝 How to Contribute

1.  **Fork the Repository:** Start by forking the `Felis-Shell-Modular-Dotfile` repository to your GitHub account.
2.  **Clone Your Fork:** Clone your forked repository to your local machine.
    ```bash
    git clone https://github.com/YOUR_USERNAME/Felis-Shell-Modular-Dotfile.git
    cd Felis-Shell-Modular-Dotfile
    ```
3.  **Create a New Branch:** Create a new branch for your feature or bug fix. Use a descriptive name (e.g., `feature/add-new-alias`, `bugfix/prompt-issue`).
    ```bash
    git checkout -b feature/your-feature-name
    ```
4.  **Make Your Changes:** Implement your changes, adhering to the [Code Style](#-code-style) guidelines.
5.  **Test Your Changes:** Thoroughly test your changes to ensure they work as expected and do not introduce new issues.
6.  **Commit Your Changes:** Write clear, concise commit messages.
    ```bash
    git add .
    git commit -m "feat: Add new useful alias for docker"
    ```
7.  **Push to Your Fork:** Push your new branch to your forked repository on GitHub.
    ```bash
    git push origin feature/your-feature-name
    ```
8.  **Open a Pull Request (PR):** Go to the original `Felis-Shell-Modular-Dotfile` repository on GitHub and open a new Pull Request from your branch. Provide a clear description of your changes, why they are needed, and any relevant testing information.

## 📝 Code Style

To maintain consistency and readability, please follow these code style guidelines:

*   **Shellcheck:** All Bash scripts should pass `shellcheck` without warnings or errors. Install it with `sudo apt install shellcheck` or `sudo pacman -S shellcheck`.
    ```bash
    shellcheck your_script.sh
    ```
*   **Indentation:** Use 4 spaces for indentation.
*   **Variable Naming:** Use `snake_case` for local variables and `UPPER_SNAKE_CASE` for global environment variables.
*   **Function Naming:** Use `lowercase_with_underscores` for function names.
*   **Comments:** Use clear and concise comments to explain complex logic or non-obvious parts of the code.
*   **Modularity:** Keep functions and scripts focused on a single responsibility. Break down large scripts into smaller, manageable files within the `.bashrc.d/functions/` directory.
*   **Error Handling:** Use `set -o pipefail` in scripts to ensure pipelines fail correctly. Include `return 1` or `exit 1` on errors where appropriate.
*   **Readability:** Prioritize clear, readable code over overly clever or condensed one-liners.

## ⚙️ Development Setup

To set up your development environment for contributing to Felis Shell:

1.  **Clone the Repository:** As described above, clone your fork.
2.  **Install Dependencies:** The `install.sh` script will help you install most recommended dependencies.
    ```bash
    cd ~/.dotfiles # Assuming you cloned to ~/.dotfiles
    ./install.sh
    ```
3.  **Test Environment:** It's recommended to test your changes in a clean environment (e.g., a new virtual machine or a Docker container) to ensure broad compatibility.
4.  **Local Testing:** After making changes, reload your shell to apply them:
    ```bash
    source ~/.bashrc
    ```
    Then, manually test the functionality you've modified or added.

## 🐛 Reporting Bugs

If you find a bug, please open an issue on the [GitHub Issues page](https://github.com/afif25fradana/Felis-Shell-Modular-Dotfile/issues). When reporting a bug, please include:

*   **Clear Title:** A concise summary of the issue.
*   **Description:** A detailed explanation of the problem.
*   **Steps to Reproduce:** Numbered steps to reliably reproduce the bug.
*   **Expected Behavior:** What you expected to happen.
*   **Actual Behavior:** What actually happened.
*   **Environment:** Your operating system, shell, terminal emulator, and any relevant versions (e.g., Bash version, Git version).
*   **Screenshots/Logs:** If applicable, include screenshots or terminal output that helps illustrate the issue.

## ✨ Feature Requests

We're always open to new ideas! If you have a feature request, please open an issue on the [GitHub Issues page](https://github.com/afif25fradana/Felis-Shell-Modular-Dotfile/issues). Describe your idea clearly and explain why you think it would be a valuable addition to Felis Shell.

Thank you for your contributions!
