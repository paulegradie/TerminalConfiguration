# TerminalConfiguration

A repo to hold my terminal configuration. Feel free to use this as a reference for your own.

I use this to quickly set up my terminal between machines.

## Windows Installation

1. Clone the repository into your personal folder so the
   [multi-identity convention](#multi-identity-convention-directory-based)
   activates automatically:

```powershell
    mkdir -Force $HOME\code\personal
    cd $HOME\code\personal
    git clone git@github.com:paulegradie/TerminalConfiguration.git
```

1. [Install Oh-My-Posh](https://ohmyposh.dev/docs/installation/windows) (via the Windows Store) or run:


    `Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://ohmyposh.dev/install.ps1'))`


1. Set your execution privileges (Run As Admin plz)

    `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Confirm`

1. Install Posh-Git

    `PowerShellGet\Install-Module posh-git -Scope CurrentUser -Force`

    OR

    `choco install poshgit`

1. Install your preferred font from `WindowsTerminal/nerdfonts` by double clicking the font file or install your favorite [NerdFont](https://www.nerdfonts.com/font-downloads) from nerdfonts.com.

    This is for supporting Oh-My-Posh themes ( you may need to go to your windows > Settings > Fonts - and install there).

1. Finally, from the repo root run `./setup-windows.ps1` (delegates to `WindowsTerminal/setup.ps1`) and restart Windows Terminal


## macOS Installation

1. Clone this repo into `~/code/personal/TerminalConfiguration` so the
   [multi-identity convention](#multi-identity-convention-directory-based)
   activates automatically:

    ```bash
    mkdir -p ~/code/personal
    cd ~/code/personal
    git clone git@github.com:paulegradie/TerminalConfiguration.git
    ```

2. From the repo root, run the mac setup script:

    ```bash
    cd ~/code/personal/TerminalConfiguration
    bash ./setup-unix.sh
    ```

3. In iTerm2, set your font to a Nerd Font (e.g., MesloLGM Nerd Font or Fira Code Nerd Font) for proper glyphs. The script installs the font via Homebrew and also copies bundled fonts into `~/Library/Fonts`.

4. Restart your terminal or run `source ~/.zshrc`.

Notes:
- This repo uses oh-my-posh for the prompt on macOS too, reusing the JSON configs in `WindowsTerminal/PoshConfigs`.
- Shell aliases live in `UnixTerminal/aliases.zsh` and are sourced from your `~/.zshrc` by the setup script.
- The previous `GitBash` directory has been replaced by `UnixTerminal`.


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
        cd .ssh
        ssh-keygen
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
        IdentityFile ~/.ssh/id_rsa
    ```
1. Go add the key to your github ssh key settings

## Personal identity guard (for shared work / personal machines)

This repo is personal but I clone it onto work machines too. Two safeguards keep
commits from going up under the wrong identity:

1. **Versioned pre-commit hook** at `.githooks/pre-commit` — blocks any commit
   whose author is not `Paul Gradie <paul.e.gradie@gmail.com>`. Catches
   `git commit --author=...` overrides too because it reads
   `git var GIT_AUTHOR_IDENT`.
2. **Repo-local git config** — the setup scripts set `user.name`, `user.email`,
   `core.hooksPath=.githooks`, and `core.sshCommand` so the right identity and
   SSH key are used in this repo regardless of the machine's global config.

### One-time per machine

On a work machine, generate a personal SSH key and add the public half to your
personal GitHub account:

```bash
# macOS / Linux
ssh-keygen -t ed25519 -C "paul.e.gradie@gmail.com" -f ~/.ssh/id_ed25519_personal
```

```powershell
# Windows
ssh-keygen -t ed25519 -C "paul.e.gradie@gmail.com" -f $HOME\.ssh\id_ed25519_personal
```

Then re-run the appropriate setup script (`setup-unix.sh` or
`setup-windows.ps1`). It wires `core.sshCommand` to that key so `git push` uses
the personal identity even though the system default key is the work one.

## Multi-identity convention (directory-based)

Repos are bucketed by directory. The right identity + SSH key is selected
automatically based on where the repo lives:

| Directory             | Identity                                  | SSH key                          |
| --------------------- | ----------------------------------------- | -------------------------------- |
| `~/code/personal/`    | `Paul Gradie <paul.e.gradie@gmail.com>`   | `~/.ssh/id_ed25519_personal`     |
| `~/code/work/`        | `Paul Gradie <paul@tilt.com>`             | `~/.ssh/id_ed25519`              |
| anywhere else         | falls back to the global `[user]` (work)  | default per `~/.ssh/config`      |

No per-repo `git config` calls. No env vars. The directory location is the
entire signal — including during the initial `git clone`, because the include
is evaluated as soon as git initialises the repo's gitdir.

### How it's wired

`~/.gitconfig`:

```ini
[user]
    name = Paul Gradie
    email = paul@tilt.com        # work, also the safe default
[includeIf "gitdir:~/code/personal/"]
    path = ~/.gitconfig-personal
[includeIf "gitdir:~/code/work/"]
    path = ~/.gitconfig-work
```

`~/.gitconfig-personal`:

```ini
[user]
    name = Paul Gradie
    email = paul.e.gradie@gmail.com
[core]
    # IdentityAgent=none keeps the agent's work key from being offered first
    # (the agent typically holds id_ed25519 = work, and ~/.ssh/config also
    # pins id_ed25519 for github.com — without this we'd auth as the work
    # account when pushing personal repos).
    sshCommand = ssh -i ~/.ssh/id_ed25519_personal -o IdentitiesOnly=yes -o IdentityAgent=none
```

`~/.gitconfig-work`:

```ini
[user]
    name = Paul Gradie
    email = paul@tilt.com
[core]
    # No IdentityAgent=none here — the agent has the work key loaded, which
    # is what we want. IdentitiesOnly=yes just makes the key choice explicit.
    sshCommand = ssh -i ~/.ssh/id_ed25519 -o IdentitiesOnly=yes
```

The trailing slash on each `gitdir:` pattern is required — it means "this
directory and anything inside it." First match wins, but in this layout the
two buckets are disjoint, so order doesn't matter.

### Cloning a repo into the right bucket

```bash
# Personal
cd ~/code/personal
git clone git@github.com:paulegradie/Sailfish.git
cd Sailfish && git config user.email   # → paul.e.gradie@gmail.com

# Work
cd ~/code/work
git clone git@github.com:tilt-platform/empower-app.git
cd empower-app && git config user.email   # → paul@tilt.com
```

### Adding a new "identity bucket"

Need a third identity (a contracting client, an OSS org, etc.)? Drop another
include into `~/.gitconfig`:

```ini
[includeIf "gitdir:~/code/clients/acme/"]
    path = ~/.gitconfig-acme
```

…and a sibling `~/.gitconfig-acme` with its own `[user]` and
`[core] sshCommand` block.

### Note about *this* repo

`TerminalConfiguration` is meant to live under `~/code/personal/` like any
other personal repo, so the `includeIf` covers it too. The repo also keeps its
own *repo-local* identity + pre-commit hook (see the section above) — belt and
braces, because this is the one repo that has to work before the global
`~/.gitconfig` is set up on a fresh machine.

### Migrating from `~/code/TerminalConfiguration`

If you have an existing clone at `~/code/TerminalConfiguration`, move it under
`~/code/personal/` and re-run setup:

```bash
# macOS / Linux
mkdir -p ~/code/personal
mv ~/code/TerminalConfiguration ~/code/personal/TerminalConfiguration
cd ~/code/personal/TerminalConfiguration
bash ./setup-unix.sh
# open a new terminal (or: exec $SHELL -l) to verify
```

```powershell
# Windows
New-Item -ItemType Directory -Force $HOME\code\personal | Out-Null
Move-Item $HOME\code\TerminalConfiguration $HOME\code\personal\TerminalConfiguration
cd $HOME\code\personal\TerminalConfiguration
./setup-windows.ps1
# restart Windows Terminal
```

The setup scripts strip stale `# TerminalConfiguration (...)` blocks from your
rc files (and stale `. "..."` profile-include lines on Windows) before
re-emitting fresh ones from the new location, so the move is idempotent — you
won't end up with duplicate `source` or `settings` definitions pointing at the
old path.

## Misc

Set code to be the default rebase editor

```git config --global core.editor "code --wait"```
