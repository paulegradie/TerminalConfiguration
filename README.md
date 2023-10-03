# SettingsAndConfigurations

This repository holds my powershell and bash profiles.

## Getting Started

First, clone this repository to your location of choice.

 - Be sure to modify Aliases and Functions to your liking. These currently hold impls specific to my setup.


## Extra

Set code to be the default rebase editor

```git config --global core.editor "code --wait"```

## Windows Installation

1. [Install Git for Windows](https://gitforwindows.org/)

2. [Install VS Code](https://code.visualstudio.com/docs/?dv=win)

3. [Create a new SSH Key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

```
    ssh-keygen -t ed25519 -C "your_email@example.com"
    # Paste your .pub key into the github settings ssh secrets
```
4. Create a `~/.ssh` directory and add a `config` file with contents using vs code

```bash
    cd ~
    mkdir .ssh
    code .ssh/config
```

5. Paste the following
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

6. Clone this settings repository

```bash
$USER = $env:USERPROFILE;
git clone git@github.com:paulegradie/SettingsAndConfigurations.git $USER/.SettingsAndConfiguration
```

7. [Install Oh-My-Posh](https://ohmyposh.dev/docs/installation/windows) (via the Windows Store)


8. Set your execution privelages (Run As Admin plz)

    `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Confirm`

9. Install Posh-Git


    `PowerShellGet\Install-Module posh-git -Scope CurrentUser -Force`

    OR

    `choco install poshgit`

10. Install your favorite [NerdFont](https://www.nerdfonts.com/font-downloads) to get access to all the symbols used in the Oh-My-Posh themes ( you may need to go to your windows > Settings > Fonts - and install there)

    https://www.nerdfonts.com/font-downloads

11. Finally, Run setup.ps1 and restart Windows Terminal

## Bash installations

My bash setup relies on having `~/.bashrc` and `~/.bash_profile` located in the home directory. These will each reference the version found in `.SettingsAndConfigurations`. e.g.:

// ~/.bashrc

    #!/usr/bin/env bash
    source .SettingsAndConfigurations/GitBash/.bash_profile

// and ~/.bash_profile

    #!/usr/bin/env bash
    source ./.SettingsAndConfigurations/GitBash/.bash_profile

With these ceated, everything should work.
