# Copyright (C) 2016 Turbo ROM
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

PRODUCT_BRAND ?= turbo

# Include the versioning makefile
include vendor/turbo/config/versioning.mk

# Google property overides
PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy

# Turbo property overides
PRODUCT_PROPERTY_OVERRIDES += \
    ro.sys.fw.bg_apps_limit=20 \
    pm.sleep.mode=1 \
    wifi.supplicant_scan_interval=180 \
    windowsmgr.max_events_per_sec=150 \
    debug.performance.tuning=1 \
    ro.ril.power_collapse=1 \
    persist.service.lgospd.enable=0 \
    persist.service.pcsync.enable=0 \
    ro.facelock.black_timeout=400 \
    ro.facelock.det_timeout=1500 \
    ro.facelock.rec_timeout=2500 \
    ro.facelock.lively_timeout=2500 \
    ro.facelock.est_max_time=600 \
    ro.facelock.use_intro_anim=false \
    ro.setupwizard.network_required=false \
    ro.setupwizard.gservices_delay=-1 \
    net.tethering.noprovisioning=true \
    persist.sys.dun.override=0 \
    ro.adb.secure=0 \
    persist.sys.root_access=0

# Include overlays
PRODUCT_PACKAGE_OVERLAYS += vendor/turbo/overlay/common
PRODUCT_PACKAGE_OVERLAYS += vendor/turbo/overlay/$(TARGET_PRODUCT)

# Boot animation configuration
ifneq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))

# determine the smaller dimension
TARGET_BOOTANIMATION_SIZE := $(shell \
  if [ $(TARGET_SCREEN_WIDTH) -lt $(TARGET_SCREEN_HEIGHT) ]; then \
    echo $(TARGET_SCREEN_WIDTH); \
  else \
    echo $(TARGET_SCREEN_HEIGHT); \
  fi )

# get a sorted list of the sizes
bootanimation_sizes := $(subst .zip,, $(shell ls vendor/turbo/prebuilt/bootanimation))
bootanimation_sizes := $(shell echo -e $(subst $(space),'\n',$(bootanimation_sizes)) | sort -rn)

# find the appropriate size and set
define check_and_set_bootanimation
$(eval TARGET_BOOTANIMATION_NAME := $(shell \
  if [ -z "$(TARGET_BOOTANIMATION_NAME)" ]; then
    if [ $(1) -le $(TARGET_BOOTANIMATION_SIZE) ]; then \
      echo $(1); \
      exit 0; \
    fi;
  fi;
  echo $(TARGET_BOOTANIMATION_NAME); ))
endef
$(foreach size,$(bootanimation_sizes), $(call check_and_set_bootanimation,$(size)))

ifeq ($(TARGET_BOOTANIMATION_HALF_RES),true)
PRODUCT_COPY_FILES += \
    vendor/turbo/prebuilt/bootanimation/halfres/$(TARGET_BOOTANIMATION_NAME).zip:system/media/bootanimation.zip
else
PRODUCT_COPY_FILES += \
    vendor/turbo/prebuilt/bootanimation/$(TARGET_BOOTANIMATION_NAME).zip:system/media/bootanimation.zip
endif
endif

# Force enable SELinux
PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

# Enable SIP+VoIP
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Proprietary LatinIME libs needed for AOSP keyboard swyping
ifneq ($(filter arm64,$(TARGET_ARCH)),)
PRODUCT_COPY_FILES += \
    vendor/turbo/prebuilt/lib/libjni_latinime.so:system/lib/libjni_latinime.so
else
PRODUCT_COPY_FILES += \
    vendor/turbo/prebuilt/lib64/libjni_latinime.so:system/lib64/libjni_latinime.so
endif

# Camera effects for devices without a vendor partition
ifneq ($(filter arm64,$(TARGET_ARCH)),)
PRODUCT_COPY_FILES +=  \
    vendor/turbo/prebuilt/media/LMspeed_508.emd:system/vendor/media/LMspeed_508.emd \
    vendor/turbo/prebuilt/media/PFFprec_600.emd:system/vendor/media/PFFprec_600.emd
endif

# Backup tool support
PRODUCT_COPY_FILES += \
    vendor/turbo/prebuilt/addon.d/50-turbo.sh:system/addon.d/50-turbo.sh \
    vendor/turbo/prebuilt/bin/backuptool.functions:system/bin/backuptool.functions \
    vendor/turbo/prebuilt/bin/backuptool.sh:system/bin/backuptool.sh

# Backup services whitelist
PRODUCT_COPY_FILES += \
    vendor/turbo/config/permissions/backup.xml:system/etc/sysconfig/backup.xml

# Additional packages
PRODUCT_PACKAGES += \
    LockClock \
    OmniSwitch

# NTFS support
PRODUCT_PACKAGES += \
    mkfs.ntfs \
    fsck.ntfs \
    mount.ntfs

# exFAT support
WITH_EXFAT ?= true
ifeq ($(WITH_EXFAT),true)
TARGET_USES_EXFAT := true
PRODUCT_PACKAGES += \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat
endif

# FFMPEG support
PRODUCT_PACKAGES += \
    libffmpeg_extractor \
    libffmpeg_omx \
    media_codecs_ffmpeg.xml

PRODUCT_PROPERTY_OVERRIDES += \
    media.sf.omx-plugin=libffmpeg_omx.so \
    media.sf.extractor-plugin=libffmpeg_extractor.so

# Additional tools
PRODUCT_PACKAGES += \
    bash \
    bzip2 \
    curl \
    libsepol \
    mke2fs \
    nano \
    strace \
    tune2fs \
    su

# Default notification/alarm sounds
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.notification_sound=Argon.ogg \
    ro.config.alarm_alert=Helium.ogg

# init.d support
PRODUCT_COPY_FILES += \
    vendor/turbo/prebuilt/bin/sysinit:system/bin/sysinit

# Turbo-specific init file
PRODUCT_COPY_FILES += \
    vendor/turbo/prebuilt/etc/init.local.rc:root/init.turbo.rc
