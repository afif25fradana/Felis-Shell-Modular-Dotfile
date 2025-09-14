# Contributing to Felis Shell

Hey there! Thanks for your interest in contributing to Felis Shell. This is a personal hobby project, and I'm excited that you'd like to help out. Any contributions, big or small, are welcome!

## 🤝 How You Can Help

1.  **Fork the Repo:** Start by forking this repository to your own GitHub account.
2.  **Clone Your Fork:** Clone your forked repo to your computer.
    ```bash
    git clone https://github.com/YOUR_USERNAME/Felis-Shell-Modular-Dotfile.git
    cd Felis-Shell-Modular-Dotfile
    ```
3.  **Create a New Branch:** Make a new branch for your changes. A descriptive name is helpful (e.g., `feature/add-cool-alias`).
    ```bash
    git checkout -b feature/your-cool-idea
    ```
4.  **Make Your Changes:** Go ahead and make your changes. Try to follow the existing code style, but don't stress too much about it.
5.  **Test Your Changes:** Make sure your changes work as expected and don't break anything.
6.  **Commit Your Changes:** Write a simple, clear commit message.
    ```bash
    git add .
    git commit -m "feat: Add a new alias for docker"
    ```
7.  **Push to Your Fork:** Push your new branch to your fork on GitHub.
    ```bash
    git push origin feature/your-cool-idea
    ```
8.  **Open a Pull Request (PR):** Head over to the original repo and open a new Pull Request. Give a quick description of what you've changed and why.

## 📝 A Few Style Tips

To keep everything looking consistent, here are a few friendly guidelines:

*   **`shellcheck`:** It's a good idea to run `shellcheck` on your scripts to catch common errors.
    ```bash
    shellcheck your_script.sh
    ```
*   **Indentation:** I use 4 spaces for indentation.
*   **Variable Names:** `snake_case` for local variables and `UPPER_SNAKE_CASE` for global ones.
*   **Function Names:** `lowercase_with_underscores` for function names.
*   **Comments:** If you write something complex, a quick comment explaining it is always helpful.
*   **Keep it Simple:** Try to keep functions and scripts focused on doing one thing well.
*   **Readability:** Clear and simple code is always better than a clever one-liner that's hard to understand.

## 🐛 Found a Bug?

If you find a bug, please open an issue on the [GitHub Issues page](https://github.com/afif25fradana/Felis-Shell-Modular-Dotfile/issues). In your issue, try to include:

*   A clear title.
*   A good description of the problem.
*   Steps to reproduce the bug.
*   What you expected to happen and what actually happened.
*   Info about your setup (OS, shell, terminal, etc.).

## ✨ Have an Idea?

If you have an idea for a new feature, feel free to open an issue to suggest it. I'm always open to new ideas!

Thanks again for your help!
