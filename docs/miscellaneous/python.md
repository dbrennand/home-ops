## Installing Python 3.11

### MacOS

!!! note

    Requires [Homebrew](https://brew.sh/).

1. Install [`pyenv`](https://github.com/pyenv/pyenv):

    ```bash
    brew update
    brew install pyenv
    ```

2. Configure your `~/.zshrc` file to initialize `pyenv`:

    ```bash
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
    echo 'eval "$(pyenv init -)"' >> ~/.zshrc
    source ~/.zshrc
    ```

3. Install Python 3.11 and set the global Python version:

    ```bash
    pyenv install 3.11.1
    pyenv global 3.11.1
    ```
