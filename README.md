# JioRouter AX6000 (JIDU6J11 Series) OpenWrt Firmware

Production-grade OpenWrt builds and device integration patches for the **JioRouter AX6000 (JIDU6J11 Series: 6111, 6411, 6611, 6811, 6911)** powered by the **Qualcomm IPQ9554 / IPQ9574** SoC (`qualcommbe/ipq95xx`).

---

## 🌟 Technical Overview & Enhancements

* **Upstream Bleeding-Edge Master:** Built against OpenWrt upstream `main` (`ca454c00b6`), modern Linux kernel **6.18.55**, GCC **14.4.0**, and `musl libc`.
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

## 📦 Supported SKUs

| Device SKU | Architecture | Radios | OpenWrt Target |
| :--- | :--- | :--- | :--- |
| **JIDU6111** | Qualcomm IPQ9554 | 2.4G 802.11ax + 5G 802.11ax | `qualcommbe/ipq95xx` |
| **JIDU6411** | Qualcomm IPQ9554 | 2.4G 802.11ax + 5G 802.11ax | `qualcommbe/ipq95xx` |
| **JIDU6611** | Qualcomm IPQ9554 | 2.4G 802.11ax + 5G 802.11ax | `qualcommbe/ipq95xx` |
| **JIDU6811** | Qualcomm IPQ9554 | 2.4G 802.11ax + 5G 802.11ax | `qualcommbe/ipq95xx` |
| **JIDU6911** | Qualcomm IPQ9554 | 2.4G 802.11ax + 5G 802.11ax | `qualcommbe/ipq95xx` |

---

## 🤖 AI Assistance & Transparency Disclosure

In compliance with open-source engineering transparency and AI attribution standards:
* **Assisted By:** Google Antigravity / Gemini Advanced Agentic Coding.
* **Role:** Automated cross-compilation pipeline management, kernel 6.18 upstream Device Tree syntax compatibility refactoring, patch generation, and package bundle curation.
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
