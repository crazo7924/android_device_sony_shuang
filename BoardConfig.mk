#
# Copyright (C) 2013-2016 The CyanogenMod Project
# Copyright (C) 2020 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Board device path
DEVICE_PATH := device/sony/shuang

# Platform
TARGET_BOARD_PLATFORM := msm8610
PRODUCT_PLATFORM := msm8610

# Architecture
TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_VARIANT := cortex-a7

# Board device headers
TARGET_SPECIFIC_HEADER_PATH := $(DEVICE_PATH)/include

# Board vendor configs
-include vendor/sony/shuang/BoardConfigVendor.mk

# Bluetooth
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(DEVICE_PATH)/bluetooth

# Camera
TARGET_HAS_LEGACY_CAMERA_HAL1 := true
TARGET_USES_NON_TREBLE_CAMERA := true
TARGET_USES_MEDIA_EXTENSIONS := true
USE_DEVICE_SPECIFIC_CAMERA := true

# Healthd
BOARD_CHARGER_ENABLE_SUSPEND := true

# OTA assert
TARGET_OTA_ASSERT_DEVICE := D2004,D2005,D2104,D2105,D2114,shuang,falconss

# Partitions information
BOARD_BOOTIMAGE_PARTITION_SIZE := 20971520
BOARD_CACHEIMAGE_PARTITION_SIZE := 209715200
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 16777216
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 1436549120
BOARD_USERDATAIMAGE_PARTITION_SIZE := 2176826880

# Partitions types
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

# Partitions blocks
BOARD_FLASH_BLOCK_SIZE := 131072

# Root extra symlinks
BOARD_ROOT_EXTRA_SYMLINKS := /data/tombstones:/tombstones

# Exclude serif fonts for saving system.img size.
EXCLUDE_SERIF_FONTS := true

# GPS
BOARD_VENDOR_QCOM_GPS_LOC_API_HARDWARE := $(TARGET_BOARD_PLATFORM)
BOARD_VENDOR_QCOM_LOC_PDK_FEATURE_SET := true
TARGET_NO_RPC := true

# Kernel configurations
BOARD_KERNEL_SEPARATED_DT := true
TARGET_CUSTOM_DTBTOOL := dtbToolLineage
BOARD_KERNEL_BASE := 0x00000000
BOARD_KERNEL_PAGESIZE := 2048
BOARD_KERNEL_CMDLINE := \
    androidboot.hardware=qcom \
    user_debug=23 maxcpus=2 \
    msm_rtb.filter=0x3F \
    ehci-hcd.park=3 \
    msm_rtb.enable=0 \
    lpj=192598 dwc3.maximum_speed=high \
    dwc3_msm.prop_chg_detect=Y \
    androidboot.bootdevice=msm_sdcc.1 \
    androidboot.selinux=permissive
BOARD_KERNEL_IMAGE_NAME := zImage
BOARD_MKBOOTIMG_ARGS := --ramdisk_offset 0x02000000 --tags_offset 0x01E00000
BOARD_FLASH_BLOCK_SIZE := 131072

# Kernel properties
TARGET_KERNEL_SOURCE := kernel/sony/msm8x10
TARGET_KERNEL_CONFIG := shuang_defconfig

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := MSM8610

# Vendor platform
BOARD_VENDOR := sony
BOARD_VENDOR_PLATFORM := shuang

# Legacy blobs
TARGET_NEEDS_PLATFORM_TEXT_RELOCATIONS := true
TARGET_PROCESS_SDK_VERSION_OVERRIDE := \
    /system/bin/mediaserver=19

# Custom init
TARGET_INIT_VENDOR_LIB := //$(DEVICE_PATH):libinit_shuang

# Dumpstate
BOARD_LIB_DUMPSTATE := libdumpstate.sony

# Images
TARGET_NO_BOOTLOADER := true
TARGET_NO_RADIOIMAGE := true

# Extra Root symlinks
BOARD_ROOT_EXTRA_SYMLINKS += /mnt/vendor/lta-label:/lta-label
BOARD_ROOT_EXTRA_SYMLINKS += /system/etc/firmware:/firmware

# Binder API
TARGET_USES_64_BIT_BINDER := true

# Audio configurations
AUDIO_FEATURE_ENABLED_FLUENCE := true
AUDIO_FEATURE_ENABLED_FM_POWER_OPT := true
AUDIO_FEATURE_ENABLED_PROXY_DEVICE := true
BOARD_USES_ALSA_AUDIO := true
AUDIO_USE_LL_AS_PRIMARY_OUTPUT := true
USE_CUSTOM_AUDIO_POLICY := 1
USE_XML_AUDIO_POLICY_CONF := 1

# Bluetooth
BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_QCOM := true
BLUETOOTH_HCI_USE_MCT := true

# Adreno driver
OVERRIDE_RS_DRIVER := libRSDriver_adreno.so

# Ion
TARGET_USES_ION := true

# FM radio
AUDIO_FEATURE_ENABLED_FM_POWER_OPT := true
BOARD_HAVE_QCOM_FM := true

# QCOM hardware
BOARD_USES_QCOM_HARDWARE := true

# WiFi
BOARD_HAS_QCOM_WLAN              := true
BOARD_WLAN_DEVICE                := qcwcn
BOARD_HOSTAPD_DRIVER             := NL80211
BOARD_HOSTAPD_PRIVATE_LIB        := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_WPA_SUPPLICANT_DRIVER      := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
WIFI_DRIVER_MODULE_NAME          := "wlan"
WIFI_DRIVER_FW_PATH_STA          := "sta"
WIFI_DRIVER_FW_PATH_AP           := "ap"
WPA_SUPPLICANT_VERSION           := VER_0_8_X

# Recovery
RECOVERY_FSTAB_VERSION := 2
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/rootdir/fstab.qcom

# QCOM common sepolicies
include device/qcom/sepolicy/sepolicy.mk

# Device sepolicies
BOARD_SEPOLICY_DIRS += \
    $(DEVICE_PATH)/sepolicy

# Vendor Interface Manifest
DEVICE_MANIFEST_FILE := $(DEVICE_PATH)/manifest.xml
