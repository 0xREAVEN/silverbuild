## Installation

To rebase an existing atomic Fedora installation to the latest build:

- First rebase to the unsigned image, to get the proper signing keys and policies installed:
  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/0xreaven/silverbuild:latest
  ```
- Clean user gnome config:
  ```
  rm -rf ~/.config/dconf/user
  rm -rf ~/.local/share/gnome-shell
  ```
  
- Reboot to complete the rebase:
  ```
  systemctl reboot
  ```
- Then rebase to the signed image, like so:
  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/0xreaven/silverbuild:latest
  ```
- Reboot again to complete the installation
  ```
  systemctl reboot
  ```
