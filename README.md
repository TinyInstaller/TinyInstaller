# TinyInstaller

TinyInstaller is a simple and easy-to-use Windows installation service for VPS. With TinyInstaller, you can install Windows on most types of VPS without the need for recovery/rescue mode. TinyInstaller also supports installation via CloudInit script, providing you with the utmost convenience. Installing Windows on VPS has never been easier and more convenient with TinyInstaller. Discover it now!

Here are some features of TinyInstaller:

- Diverse Windows versions: TinyInstaller supports the installation of various Windows versions, including Windows 10, Windows 8.1, Windows 7, Windows Server 2019, Windows Server 2016, Windows Server 2012 R2, Windows Server 2012, Windows Server 2008 R2, and Windows Server 2008.
- Easy installation: TinyInstaller offers a simple and user-friendly interface, allowing you to install Windows on VPS in just a few minutes.
- Support for installation via CloudInit script: TinyInstaller supports installation via CloudInit script, enabling you to automate the process of installing Windows on VPS.
- Automatic configuration support: After installation, the VPS will be automatically configured with IP, RDP, and Firewall settings. You can connect via RDP immediately after the installation is complete.

If you are looking for a simple, easy, and convenient Windows installation service for VPS, then TinyInstaller is the best choice for you. Register for TinyInstaller today and experience the difference!

## Requirements
Operating Systems: Ubuntu >=18, Debian >=9, CentOS >=7

## Installation Command

Copy the command below and remember to run it as root:

```console
wget https://tinyinstaller.top/setup.sh && bash setup.sh free
```

## Free Version
 - Dual boot: UEFI, BIOS
 - Only one version: Windows 2012 R2 Datacenter
 - No need for recovery/VNC
 - Support for KVM/VMware/Xen (Vultr, Digitalocean, Linode, Aws, Google, Azure, Kamatera...)
 - Random password
 - Limit one installation per IP every 6 months
## Paid Version
 - More Windows versions
 - No IP limitations
 - High speed
 - Can set fixed password
 - Purchase at tinyinstaller.top

## Traditional Installation (wget, gunzip, dd)
I have built some gzipped Windows versions in OOBE state [here](https://bit.ly/3NjRk3W) with full drivers, which you can use directly or customize as needed.
You can also use the following command directly:

```console
wget -O- {url} | gunzip | dd of=/dev/vda
```

_Note: Replace {url} and /dev/vda with the corresponding disk and location if they are different. Some VPS may use /dev/sda._

## Questions and Additional Information
Other gzipped build versions will be shared at [Kiến Thức VPS](https://www.facebook.com/groups/kienthuc.vps).
