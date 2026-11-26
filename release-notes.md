## JioRouter AX6000 OpenWrt Production Release v2026.11.26

Production-grade OpenWrt firmware builds for the JioRouter AX6000 family based on upstream OpenWrt master with Linux kernel 6.18 (supporting Qualcomm IPQ9554 unified JIDU6J11 series and MediaTek Filogic 830).

---

### Release Highlights

1. **Single Unified Qualcomm JIDU6J11 Series Image (Covers All 6 Models):**
   - Eliminated the redundant per-SKU `-6111` / `-6411` / `-6611` / `-6811` / `-6911` build split and suffix from target/image/board naming.
   - A single unified image set (`jiorouter_ax6000-jidu6j11`) now serves all **6 Qualcomm J11 SKUs**: **JIDU6111, JIDU6411, JIDU6611, JIDU6711, JIDU6811, and JIDU6911**.

2. **Cross-Maintainer Sysupgrade Compatibility & Signature Fixes:**
   - **Multi-Alias `SUPPORTED_DEVICES` & DTS `compatible`:** Both `jiorouter_ax6000-jidu6j11` (all 13 strings across unified `jidu6j11`, upstream PR #26498/#26551 `jidu6{111,411,611,711,811,911}`, and legacy `jidu6j11-{6111..6911}`) and `jiorouter_ax6000-jidu6j01` (all 6 strings across `jidu6j01` and `jidu6{201,401,601,701,801}`) match across community and prior builds.
   - **Per-Alias Sysupgrade `CONTROL` Entries:** `scripts/sysupgrade-tar.sh` embeds non-directory `sysupgrade-<alias>/CONTROL` entries alongside the single `sysupgrade-<board>/` directory so `nand_do_platform_check()` on other maintainers' running builds validates cleanly without requiring `--force`.
   - **Unsigned `fwtool` Images (`# CONFIG_SIGN_FIRMWARE is not set`):** Explicitly disabled local build-key signing (`ucert`) to prevent signature mismatches when upgrading from other maintainers' builds.
   - **Fixed Qualcomm Base-Files Scripts:** Updated `platform.sh`, `02_network`, `11-ath11k-caldata`, and `uboot-envtools` (`qualcommbe_ipq95xx`) to match the unified `jiorouter,ax6000-jidu6j11` board string and all SKU aliases.

3. **Included Platform Fixes & Full Software Suite (`=y`):**
   - Qualcomm IPQ9554 2.4GHz WCSS PIL fix (`&q6_region { status = "okay"; };`), ath11k 30 dBm / 160 MHz Band 2 unlock, RXDMA/monitor ring reduction, and 70 MiB SSH flasher UBI sizing.
   - LuCI (`luci`, `luci-ssl`, `luci-app-attendedsysupgrade`), Tailscale, WireGuard, AdGuardHome, SQM (CAKE), Samba 4, MiniDLNA, full USB tethering/modem + USB storage suite, `ttyd`, `btop`, `htop`, `iperf3`, `tcpdump`, and dynamic LED internet monitor.

---

### Supported Device SKUs & Artifacts

#### 1. Qualcomm IPQ9554 (Unified JIDU6J11 Series — JIDU6111, JIDU6411, JIDU6611, JIDU6711, JIDU6811, JIDU6911)
* `openwrt-qualcommbe-ipq95xx-jiorouter_ax6000-jidu6j11-squashfs-sysupgrade.bin`
* `openwrt-qualcommbe-ipq95xx-jiorouter_ax6000-jidu6j11-squashfs-factory.ubi`
* `openwrt-qualcommbe-ipq95xx-jiorouter_ax6000-jidu6j11-initramfs-factory.ubi`
* `openwrt-qualcommbe-ipq95xx-jiorouter_ax6000-jidu6j11-initramfs-uImage.itb`

#### 2. MediaTek Filogic 830 MT7986A (mediatek/filogic)
* **JIDU6101:**
  * `openwrt-mediatek-filogic-jiorouter_ax6000-jidu6101-squashfs-sysupgrade.bin`
  * `openwrt-mediatek-filogic-jiorouter_ax6000-jidu6101-initramfs-kernel.bin`
* **JIDU6J01 *(JIDU6201, JIDU6401, JIDU6601, JIDU6701, JIDU6801)*:**
  * `openwrt-mediatek-filogic-jiorouter_ax6000-jidu6j01-squashfs-sysupgrade.bin`
  * `openwrt-mediatek-filogic-jiorouter_ax6000-jidu6j01-initramfs-kernel.bin`

---

### Verified SHA-256 Checksums

```text
127dfb1df8f72d8e0275f38a7f937d6001c26b4db754da0d55f91b55b1a5e140  openwrt-mediatek-filogic-jiorouter_ax6000-jidu6101-initramfs-kernel.bin
d28e03b617530b4f6f919abbbca95a0d255692425f1754c722b27c9a39a98947  openwrt-mediatek-filogic-jiorouter_ax6000-jidu6101-squashfs-sysupgrade.bin
beca048d5cc20bba3001c67b135faaf9d89c49745046c3293bdd5e1e80c30247  openwrt-mediatek-filogic-jiorouter_ax6000-jidu6j01-initramfs-kernel.bin
9317716e6b4522d417d01802c0ccf67f0049d239d71873b6c2cc79736540579f  openwrt-mediatek-filogic-jiorouter_ax6000-jidu6j01-squashfs-sysupgrade.bin
b1ac3e4db1c92d566d83dfb0c2858a2f13363f5c271c4d87d8c2ad40a0ccdf3a  openwrt-qualcommbe-ipq95xx-jiorouter_ax6000-jidu6j11-initramfs-factory.ubi
09429bcbfe945b4778ad0332d2a6d331ae8f53e1c88fc13ae600e891ea84d514  openwrt-qualcommbe-ipq95xx-jiorouter_ax6000-jidu6j11-initramfs-uImage.itb
81c9c9977adc1632cf7ab1abd1d8a02de1659aec6fc2b80e677f9302f3f35442  openwrt-qualcommbe-ipq95xx-jiorouter_ax6000-jidu6j11-squashfs-factory.ubi
544813faafcc0d6add00bef1483e6606a6ec5c7b04add2b79796b34ebd4ea71a  openwrt-qualcommbe-ipq95xx-jiorouter_ax6000-jidu6j11-squashfs-sysupgrade.bin
```
