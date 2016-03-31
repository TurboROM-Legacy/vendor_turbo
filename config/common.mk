PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

# Disable excessive dalvik debug messages
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.debug.alloc=0

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/turbo/prebuilt/common/bin/backuptool.sh:system/bin/backuptool.sh \
    vendor/turbo/prebuilt/common/bin/backuptool.functions:system/bin/backuptool.functions \
    vendor/turbo/prebuilt/common/bin/50-turbo.sh:system/addon.d/50-turbo.sh
    
# Layers Backup
PRODUCT_COPY_FILES += \
    vendor/turbo/prebuilt/common/bin/71-layers.sh:system/addon.d/71-layers.sh

# Signature compatibility validation
PRODUCT_COPY_FILES += \
    vendor/turbo/prebuilt/common/bin/otasigcheck.sh:install/bin/otasigcheck.sh

# Turbo-specific init file
PRODUCT_COPY_FILES += \
    vendor/turbo/prebuilt/common/etc/init.local.rc:root/init.turbo.rc

# Proprietary latinime libs needed for Keyboard swyping
ifneq ($(arm $(TARGET_PRODUCT)),)
PRODUCT_COPY_FILES += \
    vendor/turbo/prebuilt/common/lib/libjni_latinime.so:system/lib/libjni_latinime.so
else ifneq ($(arm64 $(TARGET_PRODUCT)),)
PRODUCT_COPY_FILES += \
    vendor/turbo/prebuilt/common/lib64/libjni_latinime.so:system/lib64/libjni_latinime.so
endif

# SELinux filesystem labels
PRODUCT_COPY_FILES += \
    vendor/turbo/prebuilt/common/etc/init.d/50selinuxrelabel:system/etc/init.d/50selinuxrelabel

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Don't export PS1 in /system/etc/mkshrc.
PRODUCT_COPY_FILES += \
    vendor/turbo/prebuilt/common/etc/mkshrc:system/etc/mkshrc \
    vendor/turbo/prebuilt/common/etc/sysctl.conf:system/etc/sysctl.conf

PRODUCT_COPY_FILES += \
    vendor/turbo/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/turbo/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit \
    vendor/turbo/prebuilt/common/bin/sysinit:system/bin/sysinit

# Required packages
PRODUCT_PACKAGES += \
    Launcher3 \
    CellBroadcastReceiver \
    Development \
    su

# Additional Turbo packages
PRODUCT_PACKAGES += \
    Basic \
    LiveWallpapersPicker \
    LockClock \
    PhaseBeam \
    WallpaperPicker 

# BitSyko Layers
PRODUCT_COPY_FILES += \
    vendor/turbo/prebuilt/common/app/LayersManager/LayersManager.apk:system/app/LayersManager/LayersManager.apk

# AdAway
PRODUCT_COPY_FILES += \
    vendor/turbo/prebuilt/common/app/AdAway/AdAway.apk:system/app/AdAway/AdAway.apk

# Hide BitSyko Layers Manager app icon from launcher
PRODUCT_PROPERTY_OVERRIDES += \
    ro.layers.noIcon=noIcon

# OmniSwitch
PRODUCT_PACKAGES += \
    OmniSwitch 

# Kernel Adiutor
PRODUCT_COPY_FILES += \
    vendor/turbo/prebuilt/common/app/KernelAdiutor/KernelAdiutor.apk:system/app/KernelAdiutor/KernelAdiutor.apk

# SuperSU
PRODUCT_COPY_FILES += \
    vendor/turbo/prebuilt/common/supersu/UPDATE-SuperSU.zip:system/addon.d/UPDATE-SuperSU.zip \
    vendor/turbo/prebuilt/common/etc/init.d/99SuperSUDaemon:system/etc/init.d/99SuperSUDaemon

# ViPER4Android
PRODUCT_COPY_FILES += \
    vendor/turbo/prebuilt/common/app/ViPER4Android.apk:system/app/ViPER4Android/ViPER4Android.apk

# Extra Optional packages
PRODUCT_PACKAGES += \
    LatinIME \
    BluetoothExt

# Extra tools
PRODUCT_PACKAGES += \
    openvpn \
    e2fsck \
    mke2fs \
    tune2fs \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat \
    ntfsfix \
    ntfs-3g

# Stagefright FFMPEG plugin
PRODUCT_PACKAGES += \
    libffmpeg_extractor \
    libffmpeg_omx \
    media_codecs_ffmpeg.xml

PRODUCT_PROPERTY_OVERRIDES += \
    media.sf.omx-plugin=libffmpeg_omx.so \
    media.sf.extractor-plugin=libffmpeg_extractor.so

# easy way to extend to add more packages
-include vendor/extra/product.mk

PRODUCT_PACKAGE_OVERLAYS += vendor/turbo/overlay/common

# Boot animation include
ifneq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))

# determine the smaller dimension
TARGET_BOOTANIMATION_SIZE := $(shell \
  if [ $(TARGET_SCREEN_WIDTH) -lt $(TARGET_SCREEN_HEIGHT) ]; then \
    echo $(TARGET_SCREEN_WIDTH); \
  else \
    echo $(TARGET_SCREEN_HEIGHT); \
  fi )

# get a sorted list of the sizes
bootanimation_sizes := $(subst .zip,, $(shell ls vendor/turbo/prebuilt/common/bootanimation))
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
    vendor/turbo/prebuilt/common/bootanimation/halfres/$(TARGET_BOOTANIMATION_NAME).zip:system/media/bootanimation.zip
else
PRODUCT_COPY_FILES += \
    vendor/turbo/prebuilt/common/bootanimation/$(TARGET_BOOTANIMATION_NAME).zip:system/media/bootanimation.zip
endif
endif

# Versioning System
PRODUCT_VERSION_MAJOR = 3
PRODUCT_VERSION_MINOR = 1
PRODUCT_VERSION_MAINTENANCE = 0.1
ifdef TURBO_BUILD_EXTRA
    TURBO_POSTFIX := -$(TURBO_BUILD_EXTRA)
endif
ifndef TURBO_BUILD_TYPE
    TURBO_BUILD_TYPE := UNOFFICIAL
    PLATFORM_VERSION_CODENAME := UNOFFICIAL
endif
ifndef TURBO_BUILD_TYPE
    TURBO_BUILD_TYPE := OFFICIAL
    PLATFORM_VERSION_CODENAME := OFFICIAL
endif

ifeq ($(TURBO_BUILD_TYPE),DM)
    TURBO_POSTFIX := -$(shell date +"%m-%d-%Y")
endif

ifndef TURBO_POSTFIX
    TURBO_POSTFIX := -$(shell date +"%m-%d-%Y")
endif

PLATFORM_VERSION_CODENAME := $(TURBO_BUILD_TYPE)

# Set all versions
TURBO_VERSION := Turbo-$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(TURBO_BUILD_TYPE)$(TURBO_POSTFIX)
TURBO_MOD_VERSION := Turbo-$(TURBO_BUILD)-$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(TURBO_BUILD_TYPE)$(TURBO_POSTFIX)

PRODUCT_PROPERTY_OVERRIDES += \
    BUILD_DISPLAY_ID=$(BUILD_ID) \
    ro.turbo.version=$(TURBO_VERSION) \
    ro.modversion=$(TURBO_MOD_VERSION) \
    ro.turbo.buildtype=$(TURBO_BUILD_TYPE)

EXTENDED_POST_PROCESS_PROPS := vendor/turbo/tools/process_props.py

