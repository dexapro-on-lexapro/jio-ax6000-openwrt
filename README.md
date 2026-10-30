# JioRouter AX6000 OpenWrt Firmware (Qualcomm & MediaTek)

Production-grade OpenWrt builds and device integration patches for the **JioRouter AX6000** family, supporting both **Qualcomm IPQ9554** (JIDU6J11 Series) and **MediaTek MT7986A Filogic 830** (JIDU6101 & JIDU6J01 Series).

---

## 🌟 Technical Overview & Enhancements

* **Upstream Bleeding-Edge Master:** Built against OpenWrt upstream `main` (`ca454c00b6`), modern Linux kernels, GCC **14.4.0**, and `musl libc`.
* **Plug-and-Play USB Tethering & Cellular Dongle Suite:**
  * Full driver stack built directly into the kernel/rootfs: `kmod-usb-net-rndis`, `kmod-usb-net-cdc-ether`, `kmod-usb-net-cdc-ncm`, `kmod-usb-net-cdc-mbim`, `kmod-usb-net-qmi-wwan`, `kmod-usb-net-huawei-cdc-ncm`, `kmod-usb-net-ipheth` (Apple iPhone), `kmod-usb-net-asix`, `kmod-usb-net-asix-ax88179`, `kmod-usb-net-rtl8150`, `kmod-usb-net-rtl8152`, `kmod-usb-serial-option`, `usb-modeswitch`, `uqmi`, `umbim`.
  * Hotplug automation (`/etc/hotplug.d/net/99-usb-tethering`): dynamically provisions mobile tethering as a failover/primary WAN interface upon connection.
* **Dynamic LED Status Indicator:**
  * Real-time network health daemon (`/usr/bin/led_internet_monitor.sh`):
    * 🟢 **Solid Green**: Internet reachable (WAN gateway & DNS ping verified)
    * 🔴 **Solid Red**: Internet unreachable / cable unplugged
    * 🔴 **Red Blinking**: System bootup / initialization
* **Integrated USB Storage Support (No Snapshot Vermagic Lockup):**
  * Solves the common community snapshot issue where upstream kernel vermagic hash shifts, blocking `kmod-*` installs from online package mirrors.
  * Essential storage components (`kmod-usb-storage`, `kmod-fs-ext4`, `kmod-fs-vfat`, `block-mount`) are built directly into the SquashFS rootfs (`=y`).
* **Qualcomm `ath11k` Mode-2 Memory Optimization (`smallbuffers` Profile):**
  * Configured via device tree with `qcom,ath11k-fw-memory-mode = <2>` on both 2.4 GHz (`wifi0`) and 5 GHz (`wifi1`) radios.
  * Sets max client peers to 128 (optimal for home/lab routers) and reclaims post-boot calibration buffers (`coldboot_cal_mm = false`), saving **~15–30 MB of kernel RAM**.
  * Prevents buffer-exhaustion Out-Of-Memory (OOM) lockups caused by fragment-pinned network descriptors under sustained load.
* **Pre-bundled Userland Services:**
  * LuCI web management over HTTPS (`luci-ssl`)
  * WireGuard VPN support (`wireguard-tools`, `kmod-wireguard`, `luci-app-wireguard`)
  * Network analytics & ad blocking (`adguardhome`, `luci-app-adguardhome`, `nlbwmon`)
  * Diagnostics suite (`htop`, `iperf3`, `curl`, `tcpdump`, `ethtool`)

---

## 📦 Supported SKUs & Pre-compiled Binaries

Pre-compiled production images and cryptographic checksums are available in the **[v2026.10.30 Release](https://github.com/dwaipayandex/jio-ax6000-openwrt/releases/tag/v2026.10.30)**.

| Device SKU | Architecture | SoC / Platform | Radios | OpenWrt Target |
| :--- | :--- | :--- | :--- | :--- |
| **JIDU6111** | ARM64 (Cortex-A53) | Qualcomm IPQ9554 | 2.4G 802.11ax + 5G 802.11ax | `qualcommbe/ipq95xx` |
| **JIDU6411** | ARM64 (Cortex-A53) | Qualcomm IPQ9554 | 2.4G 802.11ax + 5G 802.11ax | `qualcommbe/ipq95xx` |
| **JIDU6611** | ARM64 (Cortex-A53) | Qualcomm IPQ9554 | 2.4G 802.11ax + 5G 802.11ax | `qualcommbe/ipq95xx` |
| **JIDU6811** | ARM64 (Cortex-A53) | Qualcomm IPQ9554 | 2.4G 802.11ax + 5G 802.11ax | `qualcommbe/ipq95xx` |
| **JIDU6911** | ARM64 (Cortex-A53) | Qualcomm IPQ9554 | 2.4G 802.11ax + 5G 802.11ax | `qualcommbe/ipq95xx` |
| **JIDU6101** | ARM64 (Cortex-A53) | MediaTek MT7986A Filogic 830 | 2.4G 802.11ax + 5G 802.11ax | `mediatek/filogic` |
| **JIDU6J01** *(6201, 6401, 6601, 6701, 6801)* | ARM64 (Cortex-A53) | MediaTek MT7986A Filogic 830 | 2.4G 802.11ax + 5G 802.11ax | `mediatek/filogic` |

---

## 🤖 AI Assistance & Transparency Disclosure

In compliance with open-source engineering transparency and AI attribution standards:
* **Assisted By:** Google Antigravity / Gemini Advanced Agentic Coding.
* **Role:** Automated cross-compilation pipeline management, kernel upstream Device Tree syntax compatibility refactoring, patch generation, dynamic LED daemon design, and package bundle curation.
* **Human Oversight:** Hardware verification, repository oversight, and direction by [@dwaipayandex](https://github.com/dwaipayandex).

---

## 🙏 Credits & Acknowledgments

This project builds upon the foundational research, hardware analysis, and open-source contributions of the OpenWrt networking community:
* **[OpenWrt Project](https://openwrt.org/)** — The extensible open-source Linux operating system for embedded routers.
* **[@Sandiep](https://github.com/Sandiep)** — Groundwork on Qualcomm IPQ95xx / JIDU6J11 hardware reverse engineering, baseline device trees, and memory buffer optimization research.
* **[@themayankraut](https://github.com/themayankraut)** — Community hardware documentation, SKU research, and partition mapping for the Jio AX6000 series.
* **Robert Marko & OpenWrt Kernel Developers** — Development of the upstream `ath11k` device-tree memory mode subsystem.

---

## ⚖️ License & Disclaimer

* **License:** This project is licensed under the [GNU General Public License v2.0 (GPL-2.0)](LICENSE), conforming to OpenWrt and Linux kernel licensing requirements.
* **Disclaimer:** Custom firmware modifications carry inherent risks. This repository provides source patches and pre-compiled software for educational, experimental, and development purposes only. No warranties or guarantees of fitness for a particular purpose are provided.
