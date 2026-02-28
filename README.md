# 🚀 My Arch Linux Dotfiles

Welcome to my personal dotfiles repository! This is where I store all my configuration files for **Arch Linux** running the **niri compositor** with **noctalia shell**. Whether you're setting up a new machine or just curious, this repo provides a complete, automated way to replicate my development environment.

![Shell](https://img.shields.io/badge/Shell-Zsh%20with%20Powerlevel10k-blue?style=flat-square&logo=gnu-bash)
![WM](https://img.shields.io/badge/WM-niri%20%2B%20noctalia-ff69b4?style=flat-square)
![Editor](<https://img.shields.io/badge/Editor-Neovim%20(LazyVim)-green?style=flat-square&logo=neovim>)
![OS](https://img.shields.io/badge/OS-Arch%20Linux-1793D1?style=flat-square&logo=arch-linux)

---

## ✨ Features

- **Fully automated installation** – Run one script to install all packages (official, AUR, and Flatpak).
- **Modular configuration management** – Use GNU Stow to symlink only the files you need.
- **Beautiful Zsh prompt** – Powerlevel10k with custom plugins (`zsh-syntax-highlighting`, `zsh-autosuggestions`, `zsh-history-substring-search`, `web-search`).
- **Terminal emulator** – Kitty with my personal theme.
- **File managers** – Nemo (with extensions) and Yazi (terminal-based).
- **Editors** – LazyVim (Neovim), Helix, and GNOME Text Editor.
- **Browsers** – Floorp, Firefox, Zen, Brave.
- **Productivity apps** – OnlyOffice, qBittorrent, GNOME Calculator, Boxes, and more.
- **AUR helper** – yay for seamless AUR package management.
- **Flatpak support** – Pre-configured Flathub remote and selected apps.
- **SSH config** – Manage your public SSH config safely (private keys never committed).

---

## 📁 Repository Structure

```
dotfiles/
├── home/                          # All dotfiles go here (stow package)
│   ├── .zshrc                     # Zsh configuration
│   ├── .p10k.zsh                  # Powerlevel10k theme config
│   ├── .gitconfig                  # Git configuration
│   ├── .ssh/                       # SSH public config (config, public keys)
│   │   ├── config
│   │   └── id_ed25519.pub
│   └── .config/                    # Application configs
│       ├── nvim/                    # Neovim (LazyVim)
│       ├── kitty/                    # Kitty terminal
│       ├── helix/                     # Helix editor
│       ├── yazi/                      # Yazi file manager
│       └── nemo/                      # Nemo actions & configs
├── install.sh                      # Main installation script (packages)
├── bootstrap.sh                     # Symlink dotfiles using stow
└── README.md                        # You are here!
```

---

## 🛠️ Prerequisites

- A fresh **Arch Linux** installation (or any Arch-based distro).
- Internet connection.
- Basic familiarity with the terminal.

---

## 🚀 Quick Start

### 1. Clone the repository

```bash
git clone git@github.com:u11kumar/Umesh-machine.git ~/dotfiles
cd ~/dotfiles
```

> 💡 **Note**: Replace `UMESH KUMAR` with your actual GitHub username.  
> If you haven't set up SSH keys yet, check the [SSH Setup](#-ssh-setup) section below.

### 2. Run the installation script

This script will:

- Update your system.
- Install all packages (official, AUR, Flatpak).
- Set up Oh My Zsh, Powerlevel10k, and Zsh plugins.
- Install LazyVim.
- Optionally symlink dotfiles at the end.

```bash
chmod +x install.sh
./install.sh
```

The script will ask for confirmation before making changes. Follow the prompts.

### 3. Apply your configurations (if not done by install.sh)

If you skipped symlinking during installation, or you want to manually manage symlinks:

```bash
./bootstrap.sh
```

This uses GNU Stow to create symlinks from `home/` to your `$HOME` directory. It **never overwrites existing files** – it only links files that don't conflict.

---

## 🔧 Managing Dotfiles with Stow

I use [GNU Stow](https://www.gnu.org/software/stow/) to keep my home directory clean. The `bootstrap.sh` script does this automatically, but you can also run stow manually:

```bash
cd ~/dotfiles
stow --no-folding -t ~ home
```

- `--no-folding` ensures that directories (like `.ssh`) are not symlinked as a whole; instead, individual files are linked, preserving any existing files inside.
- To remove all symlinks created by stow: `stow -D -t ~ home`

Add new config files to the `home/` directory, then re-run stow – it will create new symlinks automatically.

---

## 🔐 SSH Setup for GitHub

To clone this repo via SSH, set up your SSH key:

1. Generate a new key (if you don't have one):

   ```bash
   ssh-keygen -t ed25519 -C "your_email@example.com"
   ```

2. Add it to the ssh-agent:

   ```bash
   eval "$(ssh-agent -s)"
   ssh-add ~/.ssh/id_ed25519
   ```

3. Copy the public key:

   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```

4. Add it to your [GitHub SSH settings](https://github.com/settings/keys).
5. Test the connection:

   ```bash
   ssh -T git@github.com
   ```

> ⚠️ **Important**: Never commit your **private** SSH key to this repo. Only public keys and configuration files are tracked.

---

## 📦 Included Applications

| Category          | Applications                                                                                          |
| ----------------- | ----------------------------------------------------------------------------------------------------- |
| **AUR Helper**    | `yay`                                                                                                 |
| **Shell**         | Zsh, Oh My Zsh, Powerlevel10k, plugins                                                                |
| **Terminal**      | Kitty                                                                                                 |
| **Editors**       | Neovim (LazyVim), Helix, GNOME Text Editor                                                            |
| **IDEs**          | VSCodium                                                                                              |
| **File Managers** | Nemo (with extensions), Yazi                                                                          |
| **Browsers**      | Floorp, Firefox, Zen, Brave                                                                           |
| **Office**        | OnlyOffice                                                                                            |
| **Flatpak Apps**  | qBittorrent, Warehouse, NewPipe, Cine, GNOME Calculator, Boxes                                        |
| **Utilities**     | `zoxide`, `fzf`, `ripgrep`, `fd`, `7zip`, `ffmpeg`, `poppler`, `jq`, `resvg`, `imagemagick`, `peazip` |
| **System**        | niri compositor, noctalia shell (installed separately, not in this script)                            |

> 💡 The `install.sh` script installs all of these automatically.

---

## 🎨 Customization

- **Zsh theme**: Edit `~/.p10k.zsh` (after symlinking) or run `p10k configure` to reconfigure Powerlevel10k.
- **Neovim**: LazyVim is already set up. Add your own plugins in `~/.config/nvim/lua/plugins/`.
- **Kitty**: Modify `~/.config/kitty/kitty.conf`.
- **Add new configs**: Place them in the appropriate location under `home/`, commit, and re-stow.

---

## 🤝 Contributing

If you find a bug or have a suggestion, feel free to open an issue or submit a pull request. This repo is primarily for my personal use, but I'm happy to accept improvements.

---

## 📄 License

This project is licensed under the MIT License – see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgements

- [Oh My Zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [LazyVim](https://www.lazyvim.org/)
- [GNU Stow](https://www.gnu.org/software/stow/)
- All the amazing open-source developers behind the tools I use every day.

---

## 📸 Screenshots

_(Add some screenshots of your desktop, terminal, etc. here if you like!)_

---

**Enjoy your new system!** If you have any questions, feel free to reach out. 😊
