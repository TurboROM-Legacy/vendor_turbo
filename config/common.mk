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
    ro.adb.secure=0

# Include overlays
PRODUCT_PACKAGE_OVERLAYS += vendor/turbo/overlay/common
PRODUCT_PACKAGE_OVERLAYS += vendor/turbo/overlay/$(TARGET_PRODUCT)

# Enable SIP+VoIP
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Proprietary LatinIME libs needed for AOSP keyboard swyping
ifeq ($(arm $(TARGET_PRODUCT)),)
PRODUCT_COPY_FILES += \
    vendor/turbo/prebuilt/lib/libjni_latinime.so:system/lib/libjni_latinime.so
else ifeq ($(arm64 $(TARGET_PRODUCT)),)
PRODUCT_COPY_FILES += \
    vendor/turbo/prebuilt/lib64/libjni_latinime.so:system/lib64/libjni_latinime.so
endif

# Camera effects for devices without a vendor partition
ifdef ($(arm $(TARGET_PRODUCT)),)
PRODUCT_COPY_FILES +=  \
    vendor/turbo/prebuilt/media/LMspeed_508.emd:system/vendor/media/LMspeed_508.emd \
    vendor/turbo/prebuilt/media/PFFprec_600.emd:system/vendor/media/PFFprec_600.emd
endif

# Backup tool support
PRODUCT_COPY_FILES += \
    vendor/turbo/prebuilt/addon.d/50-turbo.sh:system/addon.d/50-turbo.sh \
    vendor/turbo/prebuilt/bin/backuptool.functions:system/bin/backuptool.functions \
    vendor/turbo/prebuilt/bin/backuptool.sh:system/bin/backuptool.sh

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
