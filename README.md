# JioRouter AX6000 OpenWrt Firmware (Qualcomm & MediaTek)

Production-grade OpenWrt builds and device integration patches for the **JioRouter AX6000** family, supporting both **Qualcomm IPQ9554** (JIDU6J11 Series) and **MediaTek MT7986A Filogic 830** (JIDU6101 & JIDU6J01 Series).

---

## Technical Highlights & Included Components

This release is compiled against OpenWrt bleeding-edge `main` with **Linux Kernel 6.18**, modern **GCC 14.4.0**, and **musl libc**. Every component is built directly into the root filesystem (`=y`) to provide out-of-the-box functionality without external package repository dependencies.

### 1. Plug-and-Play USB Tethering & Cellular Dongle Suite
The firmware integrates the complete Linux USB networking and mobile broadband subsystem:
* **Host Protocols:** `kmod-usb-net-rndis` (Android USB tethering), `kmod-usb-net-cdc-ether`, `kmod-usb-net-cdc-ncm`, `kmod-usb-net-cdc-mbim`.
* **Cellular Modems:** `kmod-usb-net-qmi-wwan`, `kmod-usb-net-huawei-cdc-ncm`, `kmod-usb-serial-option`, `usb-modeswitch`, `uqmi`, `umbim`.
* **iOS Support:** `kmod-usb-net-ipheth` (Apple iPhone personal hotspot tethering).
* **USB Ethernet Adapters:** `kmod-usb-net-asix`, `kmod-usb-net-asix-ax88179`, `kmod-usb-net-rtl8150`, `kmod-usb-net-rtl8152`.
* **Dynamic Hotplug Handler:** `/etc/hotplug.d/net/99-usb-tethering` automatically identifies cellular tethering interfaces (`usb0`, `eth1`, `wwan0`, etc.) upon connection and brings them up within the WAN firewall zone.

### 2. Dynamic Internet Status LED Daemon
An automated background health monitor (`/usr/bin/led_internet_monitor.sh` managed by `procd` via `/etc/init.d/led_internet_monitor`):
* Automatically detects the platform architecture (Qualcomm IPQ9554 GPIO LEDs vs. MediaTek MT7986A Filogic GPIO LEDs).
* Continuously checks default gateway reachability and verifies external DNS connectivity:
  * **Solid Green**: Active WAN connection and internet reachability verified.
  * **Solid Red**: WAN disconnected or external internet gateway unreachable.
  * **Red Blinking**: System initialization and bootup phase.

### 3. Integrated USB Storage Subsystem (No Vermagic Lockup)
On OpenWrt snapshot builds, upstream live package feeds frequently change, causing kernel vermagic hash mismatches that prevent installing out-of-tree `kmod-*` packages. To eliminate this issue:
* `kmod-usb-storage`, `kmod-fs-ext4`, `kmod-fs-vfat`, `kmod-fs-ntfs3`, `kmod-fs-exfat`, and `block-mount` are pre-compiled into the firmware.
* Full Samba 4 file sharing (`samba4-server`, `samba4-libs`, `luci-app-samba4`) and MiniDLNA streaming (`minidlna`, `luci-app-minidlna`, `ffmpeg`, `libdrm`).
* External storage devices format and mount automatically without requiring internet access or manual `opkg` installations.

### 4. Memory Optimizations, Wi-Fi Stability & Bufferbloat Mitigation
* **Qualcomm 2.4GHz WCSS Remoteproc Fix:** Explicit `&q6_region { status = "okay"; };` memory node assignment prevents remoteproc allocation failures (`error -22`), keeping the integrated IPQ9574 AHB 2.4GHz radio (`wifi0`) fully active.
* **ath11k Wi-Fi Driver Optimization Suite:**
  * Merged regulatory domain tables unlock full 30 dBm transmit power and 160 MHz channel width on Band 2 (channels 36-64).
  * Shrunk RXDMA (2048) and monitor ring buffers (256) eliminate Out-Of-Memory kernel panics under sustained multi-gigabit workloads.
  * Dedicated page-frag caches for RXDMA resolve page exhaustion leaks without legacy kmalloc penalties.
  * Idempotent external IRQ control ensures clean Wi-Fi crash recovery and service restarts.
* **Qualcomm `ath11k` Mode-2 Memory Profile (`smallbuffers`):** Configured via Device Tree (`qcom,ath11k-fw-memory-mode = <2>`) for both radios (`wifi0` and `wifi1`), saving ~15-30 MB of kernel RAM.
* **Active Queue Management (SQM / Bufferbloat Elimination):** Pre-compiled `kmod-sched-cake` (CAKE qdisc), `kmod-ifb` (Intermediate Functional Block pseudo-device for ingress traffic shaping), `kmod-sched-core`, `sqm-scripts`, and `luci-app-sqm`.
* **MediaTek Filogic Optimizations:** Fully utilizes hardware packet offloading (WED/WO flow offloading) via MediaTek's `mt76` driver suite with 4x4 MU-MIMO and beamforming enabled.

### 5. Pre-installed Management & Network Services
* **Web Interface:** Modern LuCI web administration with HTTPS support (`luci-ssl`, `attendedsysupgrade`).
* **Mesh VPN & Privacy:** Native Tailscale (`tailscale`, `tailscaled`, `luci-app-tailscale-community`), WireGuard (`kmod-wireguard`, `wireguard-tools`, `luci-app-wireguard`), and AdGuardHome (`adguardhome`, `luci-app-adguardhome`).
* **Diagnostic & Monitoring Utilities:** `ttyd` web terminal, `btop`, `htop`, `iperf3`, `tcpdump`, `ethtool`, `nano`, `curl`, and `watchcat`.

---

## Supported SKUs & Build Artifacts

Pre-compiled production images and cryptographic checksums are available on GitHub Releases:
* **[v2026.11.26 Release (Latest)](https://github.com/dexapro-on-lexapro/jio-ax6000-openwrt/releases/tag/v2026.11.26)** - Unified single Qualcomm `jidu6j11` image across all 6 J11 SKUs (6111/6411/6611/6711/6811/6911), cross-maintainer `SUPPORTED_DEVICES` & sysupgrade `CONTROL` aliases for seamless upgrades from any community/earlier build, unsigned `fwtool` metadata (`# CONFIG_SIGN_FIRMWARE is not set`), and fixed Qualcomm base-files scripts (`02_network`, `11-ath11k-caldata`, `platform.sh`, `uboot-envtools`).
* **[v2026.11.24 Release](https://github.com/dexapro-on-lexapro/jio-ax6000-openwrt/releases/tag/v2026.11.24)** - Qualcomm IPQ9554 2.4GHz WCSS PIL memory fix, ath11k 160MHz Band 2 & 30 dBm unlock, OOM buffer reduction, and 70MB UBI partition sizing.
* **[v2026.11.06 Release](https://github.com/dexapro-on-lexapro/jio-ax6000-openwrt/releases/tag/v2026.11.06)** - Full suite with Samba 4, MiniDLNA, Tailscale, AdGuardHome, SQM (CAKE), WireGuard, USB cellular tethering, and USB printing.
* **[v2026.10.30 Release](https://github.com/dexapro-on-lexapro/jio-ax6000-openwrt/releases/tag/v2026.10.30)** - Baseline production release.

| Device SKU | Architecture | SoC / Platform | Radios | OpenWrt Target | Generated Artifacts |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **JIDU6J11 Series** *(6111, 6411, 6611, 6711, 6811, 6911)* | ARM64 | Qualcomm IPQ9554 | 2.4G ax + 5G ax (4x4) | `qualcommbe/ipq95xx` | `sysupgrade.bin`, `factory.ubi`, `initramfs-uImage.itb`, `initramfs-factory.ubi` |
| **JIDU6101** | ARM64 | MediaTek MT7986A Filogic 830 | 2.4G ax + 5G ax (4x4) | `mediatek/filogic` | `squashfs-sysupgrade.bin`, `initramfs-kernel.bin` |
| **JIDU6J01** *(6201, 6401, 6601, 6701, 6801)* | ARM64 | MediaTek MT7986A Filogic 830 | 2.4G ax + 5G ax (4x4) | `mediatek/filogic` | `squashfs-sysupgrade.bin`, `initramfs-kernel.bin` |

---

## Repository Layout

```
├── LICENSE                                    # GNU General Public License v2.0
├── README.md                                  # Repository overview and build documentation
├── files/                                     # Root filesystem overlay tree
│   ├── etc/
│   │   ├── hotplug.d/net/99-usb-tethering     # Auto-configuration for USB tethered interfaces
│   │   ├── init.d/led_internet_monitor        # Procd init service for LED status daemon
│   │   └── uci-defaults/99-init-led-monitor   # First-boot automatic service enablement
│   └── usr/bin/led_internet_monitor.sh        # Dynamic network status check and LED controller
└── patches/
    ├── 0001-qualcommbe-and-mediatek-jio-support.patch # Upstream OpenWrt master git patch series
    └── target/linux/qualcommbe/dts/           # Reference Device Tree definitions
```

---

## Building From Source

To build this firmware from source using the official OpenWrt build system:

1. **Clone OpenWrt Master:**
   ```bash
   git clone https://github.com/openwrt/openwrt.git
   cd openwrt
   ```

2. **Apply the JioRouter AX6000 Patch Series:**
   ```bash
   git apply /path/to/jio-ax6000-openwrt/patches/0001-qualcommbe-and-mediatek-jio-support.patch
   ```

3. **Install Feeds:**
   ```bash
   ./scripts/feeds update -a
   ./scripts/feeds install -a
   ```

4. **Copy the Rootfs Overlay:**
   ```bash
   cp -r /path/to/jio-ax6000-openwrt/files .
   ```

5. **Configure the Target Profile:**
   * For **Qualcomm IPQ9554**: Target System: `Qualcomm Technologies, Inc. IPQ95xx (Enterprise/Carrier)`, Subtarget: `IPQ9554 / IPQ9574`, Device: Select `JioRouter AX6000 (JIDU6J11 Series)` (single unified image for 6111, 6411, 6611, 6711, 6811, and 6911).
   * For **MediaTek Filogic 830**: Target System: `MediaTek Ralink ARM`, Subtarget: `Filogic 8x0 (MT798x)`, Device: Select `JioRouter AX6000 (JIDU6101)` or `JioRouter AX6000 (JIDU6J01)`.

6. **Compile:**
   ```bash
   make -j$(nproc)
   ```

---

## AI Assistance & Transparency Disclosure

In compliance with open-source engineering transparency and AI attribution standards:
* **Tool:** Assisted by **Google Antigravity / Gemini Advanced Agentic Coding**.
* **Scope of Assistance:** Automated cross-compilation pipeline management, kernel 6.18 Device Tree syntax refactoring, dynamic LED state engine development, hotplug tethering scripting, and package curation.
* **Human Oversight:** Codebase review, verification, and maintainership led by [@dwaipayandex](https://github.com/dwaipayandex).

---

## Credits & Acknowledgments

This project is built on the research, reverse engineering, and collaborative contributions of the open-source networking community:

* **[OpenWrt Project](https://openwrt.org/)** - Foundation of the open embedded Linux distribution, packaging system, and toolchain.
* **[@Sandiep](https://github.com/Sandiep) (Sandeep Sondagar)** - Initial hardware reverse engineering, bootloader analysis, device tree authorship, and smallbuffers memory research for the Qualcomm IPQ9554 (JIDU6J11) platform; co-author of the ath11k driver optimization series (idempotent IRQ handling, private page-frag DMA caches, regulatory domain merge, and RXDMA ring buffer reduction).
* **[@adityabakare](https://github.com/adityabakare) (Aditya Bakare)** - Root-causing and fixing the 2.4GHz internal WCSS PIL reservation regression in Linux kernel 6.18 (`&q6_region { status = "okay"; };`), restoring the integrated IPQ9574 Hexagon DSP remoteproc binding.
* **[@SahilB69](https://github.com/SahilB69) (Sahil Bakshi)** - Maintenance of community snapshot builds, authoring `openwrt/iwinfo#51` for IPQ9574 SoC detection, contributing first-boot Wi-Fi activation scripts, and co-curating the modern `ath11k` patch series.
* **[@themayankraut](https://github.com/themayankraut) (Mayank Raut)** - Hardware documentation, board teardown research, SKU cross-referencing, and community support for the Jio AX6000 hardware ecosystem.
* **[@AliLostInTheDark](https://github.com/AliLostInTheDark) (Ifran Ali), [@AKoo7](https://github.com/AKoo7) (AK Sharma), and [@sh3ikh-faisal](https://github.com/sh3ikh-faisal) (Sheikh Faisal)** - Collaborative device tree refactoring and multi-SKU platform support across the JioRouter hardware line (upstream OpenWrt PR #26551 and PR #26498).
* **Robert Marko** - Upstream development and architecture of the `ath11k` firmware memory mode subsystem in the Linux kernel.
* **Michael Phan** - Upstream foundation for `ath11k` socket allocation and DMA memory leak mitigations.

---

## License & Disclaimer

* **License:** This project is licensed under the [GNU General Public License v2.0 (GPL-2.0)](LICENSE) to maintain full compatibility with the OpenWrt and Linux kernel projects.
* **Disclaimer:** Custom firmware modifications carry inherent risks. This repository provides source patches, overlays, and build artifacts for development, educational, and testing purposes only. No warranties or guarantees of fitness for a particular purpose are expressed or implied.
