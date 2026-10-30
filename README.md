# JioRouter AX6000 (JIDU6J11 Series) OpenWrt Firmware

Production-grade OpenWrt firmware for the **JioRouter AX6000 (JIDU6J11 Series: 6111, 6411, 6611, 6811, 6911)** powered by the **Qualcomm IPQ9554 / IPQ9574** SoC (`qualcommbe/ipq95xx`).

---

## 🚀 Key Features of this Build

* **Upstream OpenWrt Base:** Built on the bleeding-edge OpenWrt master branch (`ca454c00b6`), Linux kernel **6.18.55**, GCC **14.4.0**, and `musl libc`.
* **Out-of-the-Box USB Storage Support:**
  * Avoids the common snapshot repository mismatch / vermagic lockup.
  * `kmod-usb-storage`, `kmod-fs-ext4`, `kmod-fs-vfat`, and `block-mount` are pre-compiled and embedded directly into the SquashFS rootfs image. Plug-and-play USB disks without installing packages online.
* **Optimized Qualcomm `ath11k` Memory Management (`smallbuffers` / Mode-2):**
  * Configured with `qcom,ath11k-fw-memory-mode = <2>` on both 2.4 GHz (`wifi0`) and 5 GHz (`wifi1`) radios.
  * Caps maximum client peers to 128 and frees up **~15–30 MB of kernel RAM** by disabling post-boot calibration buffers (`coldboot_cal_mm = false`).
  * Protects against high-throughput Out-Of-Memory (OOM) resets when running heavy apps.
* **Pre-installed Extra Packages:**
  * `luci-ssl` (Modern Web Dashboard with HTTPS)
  * `wireguard-tools` + `kmod-wireguard` + `luci-app-wireguard`
  * `adguardhome` + `luci-app-adguardhome`
  * `nlbwmon` (Bandwidth monitor) + `luci-app-nlbwmon`
  * Diagnostics: `htop`, `iperf3`, `curl`, `tcpdump`, `ethtool`

---

## 📦 Supported SKUs

| Device SKU | Architecture | Wi-Fi Radios | Target Profile |
| :--- | :--- | :--- | :--- |
| **JIDU6111** | Qualcomm IPQ9554 | 2.4G 802.11ax + 5G 802.11ax | `qualcommbe/ipq95xx` |
| **JIDU6411** | Qualcomm IPQ9554 | 2.4G 802.11ax + 5G 802.11ax | `qualcommbe/ipq95xx` |
| **JIDU6611** | Qualcomm IPQ9554 | 2.4G 802.11ax + 5G 802.11ax | `qualcommbe/ipq95xx` |
| **JIDU6811** | Qualcomm IPQ9554 | 2.4G 802.11ax + 5G 802.11ax | `qualcommbe/ipq95xx` |
| **JIDU6911** | Qualcomm IPQ9554 | 2.4G 802.11ax + 5G 802.11ax | `qualcommbe/ipq95xx` |

---

## ⚡ Flashing Instructions (SSH Recovery Method)

No UART cables or hardware teardown required.

### Step 1: Download Required Files
From the [Releases](https://github.com/dwaipayandex/jio-ax6000-openwrt/releases) tab, download for your specific SKU:
1. `openwrt-qualcommbe-ipq95xx-jiorouter_ax6000-jidu6j11-<SKU>-initramfs-factory.ubi` (Temporary recovery flasher)
2. `openwrt-qualcommbe-ipq95xx-jiorouter_ax6000-jidu6j11-<SKU>-squashfs-sysupgrade.bin` (Permanent firmware)

### Step 2: Backup Stock MFG Partition (Recommended)
Log in to stock root SSH and save your factory manufacturing partition:
```bash
cat /proc/mtd
dd if=/dev/mtd<mfg_idx> of=/tmp/mfg.bin
```

### Step 3: Flash Initramfs Factory UBI
Upload the initramfs factory UBI to the router:
```bash
scp openwrt-qualcommbe-ipq95xx-jiorouter_ax6000-jidu6j11-<SKU>-initramfs-factory.ubi root@192.168.29.1:/tmp/
```
Format and write the inactive rootfs slot (or flash via `flash.sh`):
```bash
ubiformat /dev/mtd<rootfs_idx> -f /tmp/openwrt-qualcommbe-ipq95xx-jiorouter_ax6000-jidu6j11-<SKU>-initramfs-factory.ubi
reboot
```

### Step 4: Permanent Sysupgrade
Once the router boots into temporary OpenWrt at `192.168.1.1`:
```bash
scp openwrt-qualcommbe-ipq95xx-jiorouter_ax6000-jidu6j11-<SKU>-squashfs-sysupgrade.bin root@192.168.1.1:/tmp/
sysupgrade -n /tmp/openwrt-qualcommbe-ipq95xx-jiorouter_ax6000-jidu6j11-<SKU>-squashfs-sysupgrade.bin
```

---

## 📄 License & Credits
* Built on [OpenWrt Project](https://openwrt.org/) source code (GPLv2).
* Hardware device tree contributions and baseline ports inspired by community research from [@Sandiep](https://github.com/Sandiep) and [@themayankraut](https://github.com/themayankraut).
