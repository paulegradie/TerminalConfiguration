# TerminalConfiguration

A repo to hold my terminal configuration. Feel free to use this as a reference for your own.

I use this to quickly set up my terminal between machines.

## Windows Installation

1. Clone the repository

```
    git clone git@github.com:paulegradie/TerminalConfiguration.git
```

1. [Install Oh-My-Posh](https://ohmyposh.dev/docs/installation/windows) (via the Windows Store)


1. Set your execution privelages (Run As Admin plz)

    `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Confirm`

1. Install Posh-Git

    `PowerShellGet\Install-Module posh-git -Scope CurrentUser -Force`

    OR

    `choco install poshgit`

1. Install your perferred font from `WindowsTerminal/fonts` by double clicking the font file or install your favorite [NerdFont](https://www.nerdfonts.com/font-downloads) from nerdfonts.com.

    This is for supporting Oh-My-Posh themes ( you may need to go to your windows > Settings > Fonts - and install there).

1. Finally, run `setup.ps1` from the `WindowsTerminal` directory and restart Windows Terminal


## Non-Windows Installation

1. Clone this repo into your home directory

2. Copy the contents of the `GitBash` directory into your home directory.

Description:

Typically on terminal startup, the terminal will source your `.bashrc`, which will source your `.bash_profile`. So you'll want to place most of your configuration into the `.bash_profile``


// ~/.bashrc

    #!/usr/bin/env bash
    source ~/TerminalConfiguration/GitBash/.bash_profile

// and ~/.bash_profile

    #!/usr/bin/env bash
    source ~/TerminalConfiguration/GitBash/.bash_profile


## Setting up git credentials


1. [Install Git for Windows](https://gitforwindows.org/)

1. [Install VS Code](https://code.visualstudio.com/docs/?dv=win)

1. [Create a new SSH Key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

    ```
        ssh-keygen -t ed25519 -C "your_email@example.com"
        # Paste your .pub key into the github settings ssh secrets
    ```
1. Create a `~/.ssh` directory and add a `config` file with contents using vs code

    ```bash
        cd ~
        mkdir .ssh
        code .ssh/config
    ```

1. Paste the following
    ```
        Host *
        IdentitiesOnly yes
        AddKeysToAgent yes
        TCPKeepAlive yes

        Host github.com
        HostName github.com
        User git
        IdentityFile ~/.ssh/{key_name}_id_rsa
    ```

## Misc

Set code to be the default rebase editor

```git config --global core.editor "code --wait"```
