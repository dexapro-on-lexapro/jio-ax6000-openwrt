## JioRouter AX6000 OpenWrt Production Release v2026.11.06

Production-grade OpenWrt firmware builds for the JioRouter AX6000 family based on upstream OpenWrt master with Linux kernel 6.18.55 (supporting both Qualcomm IPQ9554 & MediaTek Filogic 830).

---

### 🌟 Release Highlights

1. **Wi-Fi Default-On & 2.4GHz Radio Verification:**
   - **Wi-Fi Enabled on First Boot:** Both MediaTek and Qualcomm images ship with Wi-Fi enabled by default across all radios (`disabled='0'` in `/lib/wifi/mac80211.uc` and staged UCI defaults sweep `/etc/uci-defaults/90-enable-wifi`).
   - **Qualcomm 2.4GHz Radio Fully Operational:** The 2.4GHz internal radio issue from early development builds is **100% resolved**. Kernel configuration enables `CONFIG_QCOM_Q6V5_WCSS=y` (PIL remoteproc) and includes complete IPQ9574 `board-2.bin` calibration and Q6/M3 firmware symlinks in `/lib/firmware/ath11k/IPQ9574/hw1.0/`, enabling `kmod-ath11k-ahb` to boot the internal 2.4GHz WCSS radio without firmware crashes.
   - **MediaTek Filogic 830:** MT7986A dual-band (2.4GHz + 5GHz) with hardware WED/WO offloading enabled via `kmod-mt7915e`, `kmod-mt7986-firmware`, and `mt7986-wo-firmware`.

2. **Enterprise Media, DLNA & Local Storage Sharing:**
   - Full Samba 4 file server (`samba4-server`, `samba4-libs`, `luci-app-samba4`).
   - MiniDLNA streaming server (`minidlna`, `luci-app-minidlna`) with full multimedia support (`BUILD_PATENTED=y`, `ffmpeg`, and `libdrm`).
   - Native filesystem support built directly into SquashFS rootfs (`kmod-fs-ntfs3`, `kmod-fs-ext4`, `kmod-fs-vfat`, `kmod-fs-exfat`, `block-mount`, `kmod-usb-storage`, `kmod-usb-storage-uas`).

3. **Mesh VPN, Privacy & Network Optimization:**
   - **Tailscale Mesh VPN:** Native `tailscale` (1.104.1), `tailscaled`, and `luci-app-tailscale-community`.
   - **WireGuard:** Kernel-accelerated `kmod-wireguard`, `wireguard-tools`, `luci-proto-wireguard`, and `luci-app-wireguard`.
   - **Network-wide Ad-Blocking:** `adguardhome` (0.107.79) and `luci-app-adguardhome`.
   - **Active Queue Management (Bufferbloat Elimination):** `luci-app-sqm`, `sqm-scripts`, and `kmod-sched-cake`.

4. **Remote Terminal & System Monitoring:**
   - Web browser terminal (`ttyd`, `luci-app-ttyd`).
   - Modern system monitors: `btop` (1.4.7), `htop`, `iperf3`, `ethtool`, `tcpdump`, `curl`, `nano`, `nlbwmon`, `luci-app-nlbwmon`, `watchcat`, and `luci-app-watchcat`.
   - System upgrade management: `luci-app-attendedsysupgrade` and `attendedsysupgrade-common`.

5. **USB Cellular / Mobile Hotspot & Printer Suite:**
   - Complete USB tethering suite (`kmod-usb-net-rndis`, `kmod-usb-net-cdc-ether`, `kmod-usb-net-cdc-ncm`, `kmod-usb-net-cdc-mbim`, `kmod-usb-net-qmi-wwan`, `kmod-usb-net-huawei-cdc-ncm`, `kmod-usb-net-ipheth`, `kmod-usb-net-asix`, `kmod-usb-net-rtl8152`, `kmod-usb-serial-option`, `kmod-usb-serial-ftdi`, `usb-modeswitch`, `uqmi`, `umbim`).
   - Network printer sharing: `p910nd`, `luci-app-p910nd`, and `kmod-usb-printer`.

---

### 📦 Comprehensive List of Included Packages

All packages are compiled directly into the rootfs image (`=y`):

* **Administration & Web UI:** `luci`, `luci-ssl`, `luci-app-attendedsysupgrade`, `attendedsysupgrade-common`, `luci-theme-bootstrap`, `rpcd`, `rpcd-mod-luci`, `uhttpd`
* **Ad-blocking & DNS:** `adguardhome`, `luci-app-adguardhome`, `dnsmasq`
* **Mesh & VPN:** `tailscale`, `tailscaled`, `luci-app-tailscale-community`, `wireguard-tools`, `kmod-wireguard`, `luci-proto-wireguard`, `luci-app-wireguard`
* **File Sharing & Media Server:** `samba4-server`, `samba4-libs`, `luci-app-samba4`, `minidlna`, `luci-app-minidlna`, `ffmpeg`, `libdrm`, `lame`
* **Filesystems & Storage:** `kmod-fs-ntfs3`, `kmod-fs-ext4`, `kmod-fs-vfat`, `kmod-fs-exfat`, `block-mount`, `kmod-usb-core`, `kmod-usb2`, `kmod-usb3`, `kmod-usb-storage`, `kmod-usb-storage-uas`, `fitblk`, `fstools`
* **QoS & Traffic Shaping:** `luci-app-sqm`, `sqm-scripts`, `kmod-sched-cake`
* **Terminal & Monitoring:** `ttyd`, `luci-app-ttyd`, `btop`, `htop`, `nlbwmon`, `luci-app-nlbwmon`, `iperf3`, `tcpdump`, `ethtool`, `nano`, `curl`, `watchcat`, `luci-app-watchcat`
* **Printing:** `p910nd`, `luci-app-p910nd`, `kmod-usb-printer`
* **Cellular & USB Modem:** `kmod-usb-net`, `kmod-usb-net-rndis`, `kmod-usb-net-cdc-ether`, `kmod-usb-net-cdc-ncm`, `kmod-usb-net-cdc-mbim`, `kmod-usb-net-qmi-wwan`, `kmod-usb-net-huawei-cdc-ncm`, `kmod-usb-net-ipheth`, `kmod-usb-net-asix`, `kmod-usb-net-asix-ax88179`, `kmod-usb-net-rtl8150`, `kmod-usb-net-rtl8152`, `kmod-usb-serial`, `kmod-usb-serial-option`, `kmod-usb-serial-wwan`, `kmod-usb-serial-ftdi`, `usb-modeswitch`, `uqmi`, `umbim`
* **Core Base & Networking:** `apk-mbedtls`, `base-files`, `ca-bundle`, `dropbear`, `firewall4`, `nftables`, `kmod-nft-offload`, `libc`, `libgcc`, `libustream-mbedtls`, `logd`, `mtd`, `netifd`, `odhcp6c`, `odhcpd-ipv6only`, `ppp`, `ppp-mod-pppoe`, `procd-ujail`, `uboot-envtools`, `uci`, `uclient-fetch`, `urandom-seed`, `urngd`
* **Wi-Fi Subsystem:** `wpad-basic-mbedtls`, `mac80211`, `kmod-mt7915e`, `kmod-mt7986-firmware`, `mt7986-wo-firmware`, `kmod-crypto-hw-safexcel` (MediaTek), `kmod-ath11k`, `kmod-ath11k-ahb`, `kmod-ath11k-pci`, `ath11k-firmware-ipq9574`, `ath11k-firmware-qcn9074`, `ipq-wifi-jiorouter_ax6000-jidu6j11`, `kmod-qcom-ppe` (Qualcomm)

---

### 📦 Supported Device SKUs & Artifacts

#### 1. Qualcomm IPQ9554 (qualcommbe)
* **JIDU6111**
* **JIDU6411**
* **JIDU6611**
* **JIDU6811**
* **JIDU6911**
*(Each SKU provides: `sysupgrade.bin`, `factory.ubi`, `initramfs-factory.ubi`, and `initramfs-uImage.itb`)*

#### 2. MediaTek Filogic 830 MT7986A (mediatek/filogic)
* **JIDU6101:** `sysupgrade.bin` & `initramfs-kernel.bin`
* **JIDU6J01 (JIDU6801):** `sysupgrade.bin` & `initramfs-kernel.bin`

---

### 🛡️ Verified SHA256 Checksums

See `SHA256SUMS` attached to the release assets for cryptographic verification.
