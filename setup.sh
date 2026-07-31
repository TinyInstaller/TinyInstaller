#!/bin/bash
# TinyInstaller Bootstrap
#
# This script downloads and launches the TinyInstaller binary.
#
# TinyInstaller is a proprietary operating system deployment and recovery tool.
# It is intended for legitimate system provisioning, disaster recovery, and OS
# reinstallation on servers and virtual machines.
#
# The downloaded binary may perform operations such as:
#   - disk partitioning
#   - formatting storage devices
#   - deploying operating system images
#   - installing bootloaders
#   - rebooting the system
#
# These operations are the intended functionality of TinyInstaller and require
# administrator privileges.
#
# Official website: https://tinyinstaller.top
# Support: support@tinyinstaller.top
export LANG=C
if [ -z "$BASH" ]; then
    bash "$0" "$@"
    exit 0
fi
if [ "$(id -u)" != "0" ]; then
    sudo bash "$0" "$@"
    exit $?
fi
if [ "$(uname -m)" = "aarch64" ]; then
    echo "ARM is not supported!"
    exit 1
fi
if ! command -v ip > /dev/null || ! command -v wget > /dev/null || ! command -v lsblk > /dev/null || ! command -v fdisk > /dev/null; then
    if command -v apt >/dev/null 2>&1; then
        apt --quiet --yes update || true
        apt --quiet --yes install iproute2 wget fdisk || true
    elif command -v dnf >/dev/null 2>&1; then
        packages=(iproute2 wget fdisk util-linux)
        for package in "${packages[@]}"; do
            dnf --quiet --assumeyes install "$package" || true
        done
    elif command -v yum >/dev/null 2>&1; then
        packages=(iproute2 wget fdisk util-linux)
            for package in "${packages[@]}"; do
            yum --quiet --assumeyes install "$package" || true
        done
    fi
fi

if ! command -v ip > /dev/null; then
	echo "Please make sure 'ip' tool is available on your system and try again."
	exit 1
fi
if ! command -v wget > /dev/null; then
	echo "Please make sure 'wget' tool is available on your system and try again."
	exit 1
fi

if ! command -v lsblk > /dev/null; then
  echo "Please make sure 'lsblk' tool is available on your system and try again."
  exit 1
fi

if ! command -v blkid > /dev/null; then
  echo "Please make sure 'blkid' tool is available on your system and try again."
  exit 1
fi

if ! command -v fdisk > /dev/null; then
  echo "Please make sure 'fdisk' tool is available on your system and try again."
  exit 1
fi

if command -v systemd-detect-virt >/dev/null; then
    case "$(systemd-detect-virt)" in
        openvz)
            echo "OpenVZ is not supported!"
            exit 1
        ;;
        lxc)
            echo "Linux container is not supported!"
            exit 1
        ;;
    esac
else
    if ! command -v hostnamectl > /dev/null; then
        echo "Please make sure 'hostnamectl' tool is available on your system and try again."
        exit 1
    fi

    if hostnamectl | grep -q "openvz"; then
        echo "Openvz is not supported!"
        exit 1;
    fi

    if hostnamectl | grep -q "lxc"; then
        echo "Linux container is not supported!"
        exit 1;
    fi
fi



downloadTinyInstaller() {
    installerUrl="$1"

    echo "Downloading TinyInstaller..."

    rm -f /usr/local/tinyinstaller /usr/local/tinyinstaller.gz

    if ! wget -4 -qO /usr/local/tinyinstaller.gz "$installerUrl"; then
        curl -LfsSo /usr/local/tinyinstaller.gz "$installerUrl" || {
            echo "Cannot download installer!"
            return 1
        }
    fi

    if [ ! -s /usr/local/tinyinstaller.gz ]; then
        echo "Cannot download installer!"
        return 1
    fi

    if ! gunzip /usr/local/tinyinstaller.gz; then
        echo "Cannot extract installer!"
        return 1
    fi

    if [ ! -s /usr/local/tinyinstaller ]; then
        echo "Cannot extract installer!"
        return 1
    fi
}

mkdir -p /usr/local
tnHosts=(https://github.com/TinyInstaller/TinyInstaller/releases/latest/download/latest-linux-amd64.gz https://dl.ticdn.top/releases/latest-linux-amd64.gz)
for tnHost in "${tnHosts[@]}"; do
    downloadTinyInstaller "$tnHost" && break
done

if [ ! -s /usr/local/tinyinstaller ]; then
    echo "Failed to download TinyInstaller!"
    exit 1
fi

echo "Starting TinyInstaller..."
chmod +x /usr/local/tinyinstaller
/usr/local/tinyinstaller "$@"

