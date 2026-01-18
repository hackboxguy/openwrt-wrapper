# openwrt-wrapper

A build wrapper for creating custom OpenWRT firmware images for different router and embedded hardware configurations. This repository provides a structured way to manage board-specific configurations, custom packages, and rootfs overlays.

## Features

- Multi-board support with separate configurations
- Custom package integration (not in mainline OpenWRT)
- Rootfs overlay for per-board customization
- Device Tree Source (DTS) file management
- Optional image signing with public/private key pairs
- Validation mode for checking configurations before building

## Supported Hardware

| Board | Description |
|-------|-------------|
| gl-mt300nv2-remote-kit | GL-iNet GL-MT300N-V2 (MIPS, MT7628) |
| gl-mt300nv2-awsiot-demo | GL-MT300N-V2 with AWS IoT demo |
| gl-mt300nv2-dlnasrv | GL-MT300N-V2 as DLNA server |
| gl-ar150-remote-kit | GL-iNet GL-AR150 (MIPS, AR9331) |
| raspi2-remote-kit | Raspberry Pi 2 (ARM) |
| raspi4-remote-kit | Raspberry Pi 4 (ARM64) |
| hlk-rm04 | Hi-Link HLK-RM04 |

## Repository Structure

```
openwrt-wrapper/
├── build-openwrt-image.sh    # Main build script
├── openwrt/                  # OpenWRT source (git submodule)
├── configs/
│   ├── extra_packages        # Global extra packages for all boards
│   ├── update-custom-package-index.sh
│   └── <board-name>/
│       ├── <board-name>      # OpenWRT .config file
│       ├── extra_packages    # Board-specific packages (optional)
│       ├── package-creator-vars  # Image signing configuration
│       ├── rootfs_overlay/   # Files to overlay on rootfs
│       ├── patches/          # Custom patches (optional)
│       │   └── custom-patch.sh
│       ├── *.dts, *.dtsi     # Device tree files (optional)
│       ├── dts-destination.txt   # DTS copy destination (optional)
│       ├── linux-config-destination.txt  # Custom kernel config (optional)
│       └── config-*          # Custom Linux kernel config (optional)
├── packages/                 # Custom OpenWRT packages
│   ├── aws-iot-device-sdk-cpp-v2/
│   ├── aws-iot-pubsub-agent/
│   ├── brbox/
│   ├── brbox-minimal/
│   ├── gloox/
│   ├── sshpass/
│   ├── usb-tempered/
│   ├── sd-mux-ctrl/
│   └── ...
└── host-utils/               # Host-side utilities
    ├── brbox-mkimage         # Image creation binary
    ├── brbox-mkuimg.sh       # uImage wrapper script
    └── create-signed-brbox-proj.sh  # Image signing script
```

## Prerequisites

- Linux build host (Ubuntu 20.04+ recommended)
- OpenWRT build dependencies:
  ```bash
  sudo apt-get install build-essential clang flex bison g++ gawk \
    gcc-multilib g++-multilib gettext git libncurses-dev libssl-dev \
    python3-distutils rsync unzip zlib1g-dev file wget
  ```
- Git with submodule support

## Getting Started

### Clone the Repository

```bash
git clone --recursive <repository-url> openwrt-wrapper
cd openwrt-wrapper
```

If you already cloned without `--recursive`:
```bash
git submodule update --init --recursive
```

### Optional: Set Up Build Caches

For faster rebuilds, create symlinks to shared download and package caches:

```bash
ln -s /path/to/shared/dl openwrt-dl
ln -s /path/to/shared/packages openwrt-packages
```

## Usage

### Basic Build

```bash
./build-openwrt-image.sh -b <board-config-name>
```

Example:
```bash
./build-openwrt-image.sh -b raspi4-remote-kit
```

### Command Line Options

| Option | Description |
|--------|-------------|
| `-b CONFIG` | **Required.** Board/system config name |
| `-v VERSION` | Image version prefix (default: 00.01) |
| `-o VERSION` | OpenWRT version/tag to checkout |
| `-k FILE` | Public key file for image signature verification |
| `-r FILE` | Private key file for signing the image |
| `-p` | Prepare only - setup folders/files without building |
| `-i` | Image only - skip full build, regenerate image |
| `-c` | Check/validate configuration only (no changes made) |
| `-h, --help` | Show help message |

### Examples

**Build with specific version:**
```bash
./build-openwrt-image.sh -b gl-mt300nv2-remote-kit -v 01.00
```

**Build with specific OpenWRT release:**
```bash
./build-openwrt-image.sh -b raspi4-remote-kit -o v23.05.0
```

**Validate configuration before building:**
```bash
./build-openwrt-image.sh -b gl-ar150-remote-kit -c
```

**Build with image signing:**
```bash
./build-openwrt-image.sh -b gl-mt300nv2-remote-kit \
  -k keys/public_key.pem \
  -r keys/private_key.pem
```

**Prepare build environment only (useful for manual configuration):**
```bash
./build-openwrt-image.sh -b raspi4-remote-kit -p
cd openwrt
make menuconfig  # Make manual adjustments
make -j$(nproc)
```

## Creating a New Board Configuration

1. Create a new directory under `configs/`:
   ```bash
   mkdir -p configs/my-board/rootfs_overlay/etc
   ```

2. Create the OpenWRT config file:
   ```bash
   cd openwrt
   make menuconfig
   cp .config ../configs/my-board/my-board
   ```

3. Add board-specific packages (optional):
   ```bash
   echo "luci nano htop" > configs/my-board/extra_packages
   ```

4. Add rootfs overlay files as needed under `configs/my-board/rootfs_overlay/`

5. Create `package-creator-vars` if image signing is needed (see existing configs for format)

## Custom Packages

The `packages/` directory contains OpenWRT package definitions for software not available in the mainline feeds:

| Package | Description |
|---------|-------------|
| aws-iot-device-sdk-cpp-v2 | AWS IoT Device SDK for C++ |
| aws-iot-pubsub-agent | AWS IoT publish/subscribe agent |
| brbox | System services (sysmgr, xmproxy, dispsrv) |
| brbox-minimal | Minimal brbox build |
| gloox | XMPP client library |
| sshpass | Non-interactive SSH password authentication |
| usb-tempered | USB temperature sensor support |
| sd-mux-ctrl | SD card multiplexer control |
| car-can-emulator | CAN bus emulator for automotive |
| openwrt-base-scripts | Base utility scripts |
| awsiot-openwrt-extensions | AWS IoT OpenWRT extensions |

These packages are automatically linked into the OpenWRT feeds during build.

## Build Output

After a successful build, images are located in:
```
openwrt/bin/targets/<target>/<subtarget>/
```

The build summary displays:
- Board configuration name
- Build version number
- Output image paths and sizes
- Signed image path (if signing was enabled)

## Image Signing

For signed firmware updates, the build system uses:
- `host-utils/create-signed-brbox-proj.sh` - Creates signed update packages
- `host-utils/brbox-mkimage` - Low-level image creation
- `host-utils/brbox-mkuimg.sh` - uImage wrapper

To enable signing:
1. Generate RSA key pair
2. Use `-k` for public key (embedded in firmware for verification)
3. Use `-r` for private key (used to sign the image)

## Troubleshooting

### Build fails with missing dependencies
Run the validation check first:
```bash
./build-openwrt-image.sh -b <board> -c
```

### OpenWRT version not found
The script will show available tags:
```bash
./build-openwrt-image.sh -b <board> -o v99.99.99  # Will list available versions
```

### Config directory not found
List available configurations:
```bash
ls configs/
```

## License

See individual package directories for their respective licenses. The wrapper scripts are provided as-is for building custom OpenWRT images.
