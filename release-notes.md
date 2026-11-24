## JioRouter AX6000 OpenWrt Production Release v2026.11.24

Production-grade OpenWrt firmware builds for the JioRouter AX6000 family based on upstream OpenWrt master with Linux kernel 6.18 (supporting Qualcomm IPQ9554 JIDU6J11 series and MediaTek Filogic 830).

---

### 🌟 Release Highlights

1. **Qualcomm IPQ9554 2.4GHz WCSS PIL Memory Region Fix:**
   - **Upstream Regression Resolution:** Upstream commit `07d8afca2af3` (`target/linux/qualcommbe: disable the IPQ9574 WCSS reservation by default`) disabled the reserved memory node `wcss@4ab00000` by default. This broke 2.4GHz Wi-Fi across community snapshots with remoteproc error `-22` (`unable to acquire memory-region`).
   - **Permanent DTS Fix:** Added explicit `&q6_region { status = "okay"; };` in `ipq9554-jiorouter-ax6000-jidu6j11.dtsi` so the Q6V5 WCSS remoteproc driver cleanly binds to the Hexagon DSP and initializes `wifi0` without failure.

2. **Upstream ath11k Wi-Fi Performance & Stability Overhaul:**
   - **Full Transmit Power & 160MHz Band 2 Unlock (`959`):** Merges regulatory domain tables to unlock full 30 dBm (1000 mW) FCC transmit power and 160 MHz channel width on 5GHz Band 2 (channels 36–64).
   - **OOM Elimination on High Throughput (`999`):** Shrinks RXDMA ring buffers (4096 → 2048) and monitor ring sizes (4096 → 256), freeing critical kernel memory and completely eliminating Out-Of-Memory kernel panics under sustained multi-gigabit traffic.
   - **Private Page-Frag Caches for RXDMA (`955`):** Adopts dedicated page fragmentation caches for DMA receive buffers, fixing long-term page leaks and replacing legacy kmalloc workarounds.
   - **Idempotent External IRQ Control (`954`):** Ensures external IRQ control handlers are idempotent, preventing race conditions or kernel panics during Wi-Fi restarts or driver reload.

3. **Zero-UART SSH Flasher Partition Resize (`vol_size=70MiB`):**
   - Expanded UBI factory kernel partition sizing from 30 MiB to 70 MiB in `ubinize.cfg`. This easily accommodates modern 63–65 MB kernel FIT images (`initramfs-uImage.itb`) with the full media and networking suite, ensuring flawless zero-UART flashing via SSH directly into the idle NAND bank.

4. **Complete Out-of-the-Box Software Suite (`=y`):**
   - **Networking & VPN:** Tailscale (1.104.1), WireGuard, AdGuardHome (0.107.79), SQM (CAKE).
   - **Storage & Media:** Samba 4 server, MiniDLNA streaming (ffmpeg + libdrm), NTFS3, EXT4, VFAT, exFAT.
   - **Cellular & Diagnostics:** Full USB 4G/5G tethering & modem suite (RNDIS, QMI, MBIM, iPhone Hotspot), ttyd web terminal, btop (1.4.7), htop, iperf3, and dynamic LED internet monitor.

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
