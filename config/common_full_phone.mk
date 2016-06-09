# Inherit common Turbo stuff
$(call inherit-product, vendor/turbo/config/common.mk)

ifeq ($(TARGET_SCREEN_WIDTH) $(TARGET_SCREEN_HEIGHT),$(space))
    PRODUCT_COPY_FILES += \
        vendor/turbo/prebuilt/bootanimation/480.zip:system/media/bootanimation.zip
endif

$(call inherit-product, vendor/turbo/config/telephony.mk)
