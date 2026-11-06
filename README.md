# JioRouter AX6000 OpenWrt Firmware (Qualcomm & MediaTek)

Production-grade OpenWrt builds and device integration patches for the **JioRouter AX6000** family, supporting both **Qualcomm IPQ9554** (JIDU6J11 Series) and **MediaTek MT7986A Filogic 830** (JIDU6101 & JIDU6J01 Series).

---

## 🌟 Technical Highlights & Included Components

This release is compiled against OpenWrt bleeding-edge `main` with **Linux Kernel 6.18.55**, modern **GCC 14.4.0**, and **musl libc**. Every component is built directly into the root filesystem (`=y`) to provide out-of-the-box functionality without external package repository dependencies.

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
  * 🟢 **Solid Green**: Active WAN connection and internet reachability verified.
  * 🔴 **Solid Red**: WAN disconnected or external internet gateway unreachable.
  * 🔴 **Red Blinking**: System initialization and bootup phase.

### 3. Integrated USB Storage Subsystem (No Vermagic Lockup)
On OpenWrt snapshot builds, upstream live package feeds frequently change, causing kernel vermagic hash mismatches that prevent installing out-of-tree `kmod-*` packages. To eliminate this issue:
* `kmod-usb-storage`, `kmod-fs-ext4`, `kmod-fs-vfat`, and `block-mount` are pre-compiled into the firmware.
* External storage devices format and mount automatically without requiring internet access or manual `opkg` installations.

### 4. Memory Optimizations & Kernel Stability
* **Qualcomm `ath11k` Mode-2 Memory Profile (`smallbuffers`):** Configured via Device Tree (`qcom,ath11k-fw-memory-mode = <2>`) for both radios (`wifi0` and `wifi1`). Capping maximum client associations to 128 and reclaiming post-boot calibration buffers (`coldboot_cal_mm = false`) saves **~15–30 MB of kernel RAM** and prevents Out-Of-Memory (OOM) conditions under heavy concurrent connections.
* **`ath11k` RX Ring Buffer `kmalloc` Patch:** Backports independent `kmalloc`-backed socket buffer allocations for DMA RX rings, eliminating page fragmentation drain over long running uptimes.
* **MediaTek Filogic Optimizations:** Fully utilizes hardware packet offloading (flow offloading) via MediaTek's `mt76` driver suite with 4x4 MU-MIMO and beamforming enabled.

### 5. Pre-installed Management & Network Services
* **Web Interface:** Modern LuCI web administration with HTTPS support (`luci-ssl`).
* **Secure Networking:** WireGuard kernel support and web management (`kmod-wireguard`, `wireguard-tools`, `luci-app-wireguard`).
* **Content Filtering & Metrics:** Integrated `adguardhome`, `luci-app-adguardhome`, and traffic accounting via `nlbwmon` / `luci-app-nlbwmon`.
* **Diagnostic Utilities:** `htop`, `iperf3`, `tcpdump`, `ethtool`, and `curl`.

---

## 📦 Supported SKUs & Build Artifacts

Pre-compiled production images and cryptographic checksums are available on GitHub Releases:
* **[v2026.11.06 Release (Latest)](https://github.com/dexapro-on-lexapro/jio-ax6000-openwrt/releases/tag/v2026.11.06)** — Full suite with Samba 4, MiniDLNA, Tailscale, AdGuardHome, SQM (CAKE), WireGuard, USB cellular tethering, and USB printing.
* **[v2026.10.30 Release](https://github.com/dexapro-on-lexapro/jio-ax6000-openwrt/releases/tag/v2026.10.30)** — Baseline production release.

| Device SKU | Architecture | SoC / Platform | Radios | OpenWrt Target | Generated Artifacts |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **JIDU6111** | ARM64 | Qualcomm IPQ9554 | 2.4G ax + 5G ax (4x4) | `qualcommbe/ipq95xx` | `sysupgrade.bin`, `factory.ubi`, `initramfs-uImage.itb`, `initramfs-factory.ubi` |
| **JIDU6411** | ARM64 | Qualcomm IPQ9554 | 2.4G ax + 5G ax (4x4) | `qualcommbe/ipq95xx` | `sysupgrade.bin`, `factory.ubi`, `initramfs-uImage.itb`, `initramfs-factory.ubi` |
| **JIDU6611** | ARM64 | Qualcomm IPQ9554 | 2.4G ax + 5G ax (4x4) | `qualcommbe/ipq95xx` | `sysupgrade.bin`, `factory.ubi`, `initramfs-uImage.itb`, `initramfs-factory.ubi` |
| **JIDU6811** | ARM64 | Qualcomm IPQ9554 | 2.4G ax + 5G ax (4x4) | `qualcommbe/ipq95xx` | `sysupgrade.bin`, `factory.ubi`, `initramfs-uImage.itb`, `initramfs-factory.ubi` |
| **JIDU6911** | ARM64 | Qualcomm IPQ9554 | 2.4G ax + 5G ax (4x4) | `qualcommbe/ipq95xx` | `sysupgrade.bin`, `factory.ubi`, `initramfs-uImage.itb`, `initramfs-factory.ubi` |
| **JIDU6101** | ARM64 | MediaTek MT7986A Filogic 830 | 2.4G ax + 5G ax (4x4) | `mediatek/filogic` | `squashfs-sysupgrade.bin`, `initramfs-kernel.bin` |
| **JIDU6J01** *(6201, 6401, 6601, 6701, 6801)* | ARM64 | MediaTek MT7986A Filogic 830 | 2.4G ax + 5G ax (4x4) | `mediatek/filogic` | `squashfs-sysupgrade.bin`, `initramfs-kernel.bin` |

---

## 📂 Repository Layout

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

## 🛠️ Building From Source

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
   * For **Qualcomm IPQ9554**: Target System: `Qualcomm Technologies, Inc. IPQ95xx (Enterprise/Carrier)`, Subtarget: `IPQ9554 / IPQ9574`, Device: Select your `JioRouter AX6000 JIDU6*11` model.
   * For **MediaTek Filogic 830**: Target System: `MediaTek Ralink ARM`, Subtarget: `Filogic 8x0 (MT798x)`, Device: Select `JioRouter AX6000 (JIDU6101)` or `JioRouter AX6000 (JIDU6J01)`.

6. **Compile:**
   ```bash
   make -j$(nproc)
   ```

---

## 🤖 AI Assistance & Transparency Disclosure

In compliance with open-source engineering transparency and AI attribution standards:
* **Tool:** Assisted by **Google Antigravity / Gemini Advanced Agentic Coding**.
* **Scope of Assistance:** Automated cross-compilation pipeline management, kernel 6.18 Device Tree syntax refactoring, dynamic LED state engine development, hotplug tethering scripting, and package curation.
* **Human Oversight:** Codebase review, verification, and maintainership led by [@dwaipayandex](https://github.com/dwaipayandex).

---

## 🙏 Credits & Acknowledgments

This project is built on the research, reverse engineering, and collaborative contributions of the open-source networking community:
* **[OpenWrt Project](https://openwrt.org/)** — Foundation of the open embedded Linux distribution and toolchain.
* **[@Sandiep](https://github.com/Sandiep)** (Sandeep Sondagar) — Initial hardware reverse engineering, bootloader analysis, device tree authorship, and smallbuffers memory research for the Qualcomm IPQ9554 (JIDU6J11) platform.
* **[@themayankraut](https://github.com/themayankraut)** (Mayank Raut) — Hardware documentation, SKU cross-referencing, and community support for the Jio AX6000 hardware platform.
* **Robert Marko** — Upstream development of the `ath11k` firmware memory mode subsystem in the Linux kernel.
* **Michael Phan** — Upstream patch for `ath11k` RX ring buffer `kmalloc`-backed socket allocation to address long-term memory leaks.

---

## ⚖️ License & Disclaimer

* **License:** This project is licensed under the [GNU General Public License v2.0 (GPL-2.0)](LICENSE) to maintain full compatibility with the OpenWrt and Linux kernel projects.
* **Disclaimer:** Custom firmware modifications carry inherent risks. This repository provides source patches, overlays, and build artifacts for development, educational, and testing purposes only. No warranties or guarantees of fitness for a particular purpose are expressed or implied.
