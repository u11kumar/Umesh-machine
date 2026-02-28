# 🏗️ Setting Up Arch Linux with Niri and Noctalia Shell

This guide will walk you through setting up a fresh Arch Linux installation with the **niri compositor** and **noctalia shell**. All commands are provided in easy copy-paste blocks.

---

## 📡 Prerequisites

- You have successfully installed Arch Linux (base system) and rebooted into it.
- You have root access or sudo privileges.
- You have an internet connection (we'll use `nmtui` to connect to Wi-Fi if needed).

---

## 🔌 Step 1: Connect to Wi-Fi (if using wireless)

If you're using Ethernet, you can skip this step.

```bash
# Start the NetworkManager Text User Interface
sudo nmtui
```

- Use arrow keys to navigate to **"Activate a connection"** and press Enter.
- Select your Wi-Fi network, enter the password, and wait for activation.
- Exit `nmtui` (select "Quit").

Test your connection:

```bash
ping -c 3 archlinux.org
```

---

## 📦 Step 2: Update System and Install Base Packages

Update the package database and upgrade all packages:

```bash
sudo pacman -Syu
```

Install essential tools (git, curl, wget, base-devel):

```bash
sudo pacman -S --needed git curl wget base-devel
```

---

## 🤖 Step 3: Install an AUR Helper (yay)

We'll use `yay` to install packages from the Arch User Repository (AUR).

```bash
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay
```

Verify installation:

```bash
yay --version
```

---

## 🪟 Step 4: Install Niri and Core Dependencies

Install niri, xwayland-satellite, and portal packages from the official repos:

```bash
sudo pacman -S niri xwayland-satellite xdg-desktop-portal-gnome xdg-desktop-portal-gtk alacritty
```

---

## 🐚 Step 5: Install Noctalia Shell and Its Dependencies

### 5.1 Install AUR packages needed for noctalia

```bash
yay -S dms-shell-bin matugen cava qt6-multimedia-ffmpeg
```

### 5.2 Install additional tools (some may already be installed)

```bash
sudo pacman -S brightnessctl imagemagick python
```

> Note: `brightnessctl` is for backlight control, `imagemagick` for image processing, `python` for scripts.

### 5.3 Install ddcutil (for monitor control)

```bash
yay -S ddcutil
```

### 5.4 Install other utilities

```bash
yay -S cliphist cava wlsunset xdg-desktop-portal python3 evolution-data-server
```

> `cava` might already be installed; it's fine to run again.

---

## 📥 Step 6: Download and Extract Noctalia Shell

Create the target directory and download the latest release:

```bash
mkdir -p ~/.config/quickshell/noctalia-shell
curl -sL https://github.com/noctalia-dev/noctalia-shell/releases/latest/download/noctalia-latest.tar.gz | tar -xz --strip-components=1 -C ~/.config/quickshell/noctalia-shell
```

This places the shell files in `~/.config/quickshell/noctalia-shell`.

---

## ⚙️ Step 7: Enable Noctalia to Start with Niri

The `dms` service (noctalia's daemon) should be started together with niri. Use systemd user service dependencies:

```bash
systemctl --user add-wants niri.service dms
```

This ensures `dms` starts when niri starts.

---

## 🚀 Step 8: Start Niri

You can now start niri from a TTY or your display manager. If you're using a display manager (like SDDM), select "niri" from the session menu. If not, add the following to your `~/.xinitrc` or start it manually:

```bash
exec niri
```

But for a proper Wayland session, it's better to use a display manager or create a session file. You can also start it from the console:

```bash
niri
```

---

## ✅ Verification

After logging into niri, you should see the noctalia shell. Check that all services are running:

```bash
systemctl --user status dms
```

---

## 📝 Troubleshooting

- **Wi-Fi not working?** Ensure NetworkManager is enabled and started:  
  `sudo systemctl enable --now NetworkManager`
- **Missing packages?** Double-check the package names. Some may have been renamed.
- **Noctalia not appearing?** Make sure the extraction completed successfully and that `dms` is running.

---

## 📚 Additional Notes

- The `paru` commands in your original list are replaced with `yay` here. You can install `paru` similarly if you prefer.
- The `systemctl --user add-wants` command is a one-time setup. It creates a dependency link.
- If you encounter any issues, refer to the official documentation:
  - [Niri Wiki](https://github.com/YaLTeR/niri/wiki)
  - [Noctalia Shell](https://github.com/noctalia-dev/noctalia-shell)

---

**Enjoy your new Arch + Niri + Noctalia setup!** 🎉
