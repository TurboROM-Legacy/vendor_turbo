# Inherit common stuff
$(call inherit-product, vendor/turbo/config/common.mk)

PRODUCT_PACKAGE_OVERLAYS += vendor/turbo/overlay/tablet

# BT config
PRODUCT_COPY_FILES += \
    system/bluetooth/data/main.nonsmartphone.conf:system/etc/bluetooth/main.conf
