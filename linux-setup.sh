#!/bin/bash

# --- Detect Distro & Package Manager ---
detect_system() {
    if command -v apt &> /dev/null; then
        DISTRO="Debian/Ubuntu"
        PKG_INSTALL="apt install -y"
        PKG_REMOVE="apt remove -y"
        PKG_UPDATE="apt update && apt upgrade -y"
    elif command -v dnf &> /dev/null; then
        DISTRO="Fedora/RHEL"
        PKG_INSTALL="dnf install -y"
        PKG_REMOVE="dnf remove -y"
        PKG_UPDATE="dnf upgrade -y"
    elif command -v pacman &> /dev/null; then
        DISTRO="Arch/Manjaro"
        PKG_INSTALL="pacman -S --noconfirm"
        PKG_REMOVE="pacman -Rns"
        PKG_UPDATE="pacman -Syu --noconfirm"
    elif command -v zypper &> /dev/null; then
        DISTRO="OpenSUSE"
        PKG_INSTALL="zypper install -y"
        PKG_REMOVE="zypper remove -y"
        PKG_UPDATE="zypper update -y"
    else
        echo "Error: Unsupported distro. Manual setup required."
        exit 1
    fi
}

# --- Update System ---
update_system() {
    echo "--- Updating system packages ---"
    $PKG_UPDATE
}

# --- Install Gaming Dependencies ---
install_gaming() {
    echo "--- Installing gaming dependencies ---"
    case $DISTRO in
        "Debian/Ubuntu")
            $PKG_INSTALL steam flatpak gdebi vulkan-tools mesa-utils libgl1-mesa-dri libgl1-mesa-glx
            flatpak install flathub com.valvesoftware.Steam
            ;;
        "Arch/Manjaro")
            $PKG_INSTALL steam flatpak vulkan-intel lib32-vulkan-intel lib32-nvidia-utils
            flatpak install flathub com.valvesoftware.Steam
            ;;
        "Fedora/RHEL")
            $PKG_INSTALL steam flatpak vulkan-tools mesa-libGL
            flatpak install flathub com.valvesoftware.Steam
            ;;
        "OpenSUSE")
            $PKG_INSTALL steam flatpak vulkan-tools Mesa-libGL1
            flatpak install flathub com.valvesoftware.Steam
            ;;
    esac
}

# --- Install Development Tools ---
install_dev() {
    echo "--- Installing development tools ---"
    case $DISTRO in
        "Debian/Ubuntu")
            $PKG_INSTALL build-essential git cmake gcc g++ python3 python3-pip
            ;;
        "Arch/Manjaro")
            $PKG_INSTALL base-devel git cmake gcc python python-pip
            ;;
        "Fedora/RHEL")
            $PKG_INSTALL "@Development Tools" git cmake gcc python3 python3-pip
            ;;
        "OpenSUSE")
            $PKG_INSTALL Pattern:devel_C_C++ git cmake gcc python3 python3-pip
            ;;
    esac
}

# --- Install Multimedia ---
install_multimedia() {
    echo "--- Installing multimedia tools ---"
    case $DISTRO in
        "Debian/Ubuntu")
            $PKG_INSTALL vlc ffmpeg gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly
            ;;
        "Arch/Manjaro")
            $PKG_INSTALL vlc ffmpeg gst-plugins-good gst-plugins-bad gst-plugins-ugly
            ;;
        "Fedora/RHEL")
            $PKG_INSTALL vlc ffmpeg gstreamer1-plugins-good gstreamer1-plugins-bad-free gstreamer1-plugins-ugly-free
            ;;
        "OpenSUSE")
            $PKG_INSTALL vlc ffmpeg gstreamer-plugins-good gstreamer-plugins-bad gstreamer-plugins-ugly
            ;;
    esac
}

# --- Install Flatpak Apps ---
install_flatpak() {
    echo "--- Installing Flatpak apps ---"
    flatpak install flathub \
        com.spotify.Client \
        org.gnome.Totem \
        com.github.tchx84.Flatseal \
        com.visualstudio.code
}

# --- Main Menu ---
main_menu() {
    detect_system
    update_system

    while true; do
        clear
        echo "=== Linux Setup Assistant ==="
        echo "Detected: $DISTRO"
        echo "1. Install Gaming Dependencies"
        echo "2. Install Development Tools"
        echo "3. Install Multimedia Tools"
        echo "4. Install Flatpak Apps"
        echo "5. Exit"
        read -p "Select an option (1-5): " choice

        case $choice in
            1) install_gaming ;;
            2) install_dev ;;
            3) install_multimedia ;;
            4) install_flatpak ;;
            5) exit 0 ;;
            *) echo "Invalid option. Try again." ;;
        esac
    done
}

# --- Run ---
main_menu
