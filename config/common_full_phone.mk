# Inherit common stuff
$(call inherit-product, vendor/turbo/config/common.mk)
$(call inherit-product, vendor/turbo/config/common_apn.mk)

# SIM Toolkit
PRODUCT_PACKAGES += \
    Stk
