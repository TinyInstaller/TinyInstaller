#!/bin/bash
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
	echo "Installing dependencies..."
	if [ -e /etc/debian_version ]; then
        	apt-get --quiet --yes update || true
		apt-get --quiet --quiet --yes install iproute2 wget fdisk || true
	else
        packages=("iproute2" "wget" "fdisk" "util-linux")
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

if ! command -v base64 > /dev/null; then
	echo "Please make sure 'base64' tool is available on your system and try again."
	exit 1
fi

downloadInstaller() {
    installUrl=$(echo $1 | base64 -d -i)
    echo "Downloading installer..."
    rm -f /usr/local/tinstaller
    wget -4 --no-check-certificate -qO /usr/local/tinstaller "$installUrl" || curl "$installUrl" -Lso /usr/local/tinstaller
    if [ ! -s /usr/local/tinstaller ]; then
        echo "Cannot to download installer!"
        return 1
    fi
    return 0
}

mkdir -p /usr/local
tnHosts=("aHR0cHM6Ly90aW55aW5zdGFsbGVyLnRvcC9pbnN0YWxsLnNo" "aHR0cHM6Ly9mMS5oaHViLnRvcC9pbnN0YWxsLnNo" "aHR0cHM6Ly9mMi5oaHViLnRvcC9pbnN0YWxsLnNo" "aHR0cHM6Ly9mMy5oaHViLnRvcC9pbnN0YWxsLnNo" "aHR0cHM6Ly9mNC5oaHViLnRvcC9pbnN0YWxsLnNo" "aHR0cHM6Ly9mNS5oaHViLnRvcC9pbnN0YWxsLnNo" "aHR0cHM6Ly9mNi5oaHViLnRvcC9pbnN0YWxsLnNo" "aHR0cHM6Ly9mNy5oaHViLnRvcC9pbnN0YWxsLnNo" "aHR0cHM6Ly9mOC5oaHViLnRvcC9pbnN0YWxsLnNo" "aHR0cHM6Ly9mOS5oaHViLnRvcC9pbnN0YWxsLnNo" "aHR0cHM6Ly9mMTAuaGh1Yi50b3AvaW5zdGFsbC5zaA==" )
for tnHost in "${tnHosts[@]}"; do
    downloadInstaller "$tnHost" && break
done

if [ ! -s /usr/local/tinstaller ]; then
    echo "Failed to download install script!"
    exit 1
fi

chmod +x /usr/local/tinstaller
clear
/usr/local/tinstaller "$@"


