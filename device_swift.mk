## This device is the LG GT540 Swift, and all its variants, which include:

#

# The gps config appropriate for this device
$(call inherit-product, device/common/gps/gps_eu_supl.mk)

DEVICE_PACKAGE_OVERLAYS += device/lge/swift/overlay

# HAL libs and other system binaries
PRODUCT_PACKAGES += \
 hwprops \
 lights.swift \
 copybit.swift \
 gralloc.swift \
 gps.swift \
 sensors.swift \
 libmm-omxcore \
 libOmxCore \
 liblgdrm \
 liblgeat \
 liblgerft \
 brcm_patchram_plus \
 bdaddr_read \
 FM \
 SwiftParts

# Extra apps
PRODUCT_PACKAGES += \
	Launcher2  


ifeq ($(TARGET_PREBUILT_KERNEL),)
    LOCAL_KERNEL := device/lge/swift/prebuilt/kernel
else
    LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
endif

PRODUCT_COPY_FILES += \
    $(LOCAL_KERNEL):kernel


# Live wallpaper packages
PRODUCT_PACKAGES += \
    LiveWallpapers \
    LiveWallpapersPicker \
    MagicSmokeWallpapers \
    VisualizationWallpapers \
    librs_jni

# Publish that we support the live wallpaper feature.
PRODUCT_COPY_FILES += \
    packages/wallpapers/LivePicker/android.software.live_wallpaper.xml:/system/etc/permissions/android.software.live_wallpaper.xml



PRODUCT_COPY_FILES += \
	device/lge/swift/files/07swapon:system/etc/init.d/07swapon

# Board-specific init
PRODUCT_COPY_FILES += \
    device/lge/swift/ueventd.qct.rc:root/ueventd.qct.rc \
    device/lge/swift/init.qcom.rc:root/init.qcom.rc

#Kernel modules 
PRODUCT_COPY_FILES += \
   device/lge/swift/prebuilt/compcache/zram.ko:system/lib/modules/zram.ko \
   device/lge/swift/prebuilt/wifi/wireless.ko:system/lib/modules/wireless.ko 

## RIL related stuff
PRODUCT_COPY_FILES += \
   device/lge/swift/files/spn-conf.xml:system/etc/spn-conf.xml \
   device/lge/swift/proprietary/bin/qmuxd:system/bin/qmuxd \
   device/lge/swift/proprietary/lib/liboncrpc.so:system/lib/liboncrpc.so \
   device/lge/swift/proprietary/lib/libmmgsdilib.so:system/lib/libmmgsdilib.so \
   device/lge/swift/proprietary/lib/libgsdi_exp.so:system/lib/libgsdi_exp.so \
   device/lge/swift/proprietary/lib/libgstk_exp.so:system/lib/libgstk_exp.so \
   device/lge/swift/proprietary/lib/libwms.so:system/lib/libwms.so \
   device/lge/swift/proprietary/lib/libnv.so:system/lib/libnv.so \
   device/lge/swift/proprietary/lib/libwmsts.so:system/lib/libwmsts.so \
   device/lge/swift/proprietary/lib/libdss.so:system/lib/libdss.so \
   device/lge/swift/proprietary/lib/libqmi.so:system/lib/libqmi.so \
   device/lge/swift/proprietary/lib/libdiag.so:system/lib/libdiag.so \
   device/lge/swift/proprietary/lib/libpbmlib.so:system/lib/libpbmlib.so \
   device/lge/swift/proprietary/lib/libauth.so:system/lib/libauth.so \
   device/lge/swift/proprietary/lib/liboem_rapi.so:system/lib/liboem_rapi.so \
   device/lge/swift/proprietary/lib/libdsm.so:system/lib/libdsm.so \
   device/lge/swift/proprietary/lib/libqueue.so:system/lib/libqueue.so \
   device/lge/swift/proprietary/lib/libcm.so:system/lib/libcm.so \
   device/lge/swift/proprietary/lib/libdll.so:system/lib/libdll.so \
   device/lge/swift/proprietary/lib/libril-qc-1.so:system/lib/libril-qc-1.so \
   device/lge/swift/proprietary/lib/libril-qcril-hook-oem.so:system/lib/libril-qcril-hook-oem.so\
   device/lge/swift/proprietary/lib/libril_log.so:system/lib/libril_log.so

## LG RIL DRM Files have been replaced with source stud
# 

PRODUCT_COPY_FILES += \
#   device/lge/swift/proprietary/lib/liblgdrm.so:system/lib/liblgdrm.so \
#   device/lge/swift/proprietary/lib/liblgeat.so:system/lib/liblgeat.so \
#   device/lge/swift/proprietary/lib/liblgerft.so:system/lib/liblgerft.so \
   device/lge/swift/proprietary/lib/libbcmwl.so:system/lib/libbcmwl.so


# GPS
PRODUCT_COPY_FILES += \
	device/lge/swift/files/gps.conf:system/etc/gps.conf \
	device/lge/swift/proprietary/lib/gps/libcommondefs.so:system/lib/libcommondefs.so \
	device/lge/swift/proprietary/lib/gps/libgps.so:system/lib/libgps.so \
	device/lge/swift/proprietary/lib/gps/libloc_api.so:system/lib/libloc_api.so \
	device/lge/swift/proprietary/lib/gps/libloc-rpc.so:system/lib/libloc-rpc.so \
	device/lge/swift/proprietary/lib/gps/libloc.so:system/lib/libloc.so \
	device/lge/swift/proprietary/lib/gps/libloc.so:obj/lib/libloc.so
#	device/lg/swift/proprietary/lib/gps/librpc.so:system/lib/librpc.so 

# OMX proprietaries
PRODUCT_COPY_FILES += \
    device/lge/swift/proprietary/lib/omx/libmm-adspsvc.so:system/lib/libmm-adspsvc.so \
    device/lge/swift/proprietary/lib/omx/libOmxAacDec.so:system/lib/libOmxAacDec.so \
    device/lge/swift/proprietary/lib/omx/libOmxAmrRtpDec.so:system/lib/libOmxAmrRtpDec.so \
    device/lge/swift/proprietary/lib/omx/libOmxH264Dec.so:system/lib/libOmxH264Dec.so \
    device/lge/swift/proprietary/lib/omx/libOmxQcelpDec.so:system/lib/libOmxQcelpDec.so \
    device/lge/swift/proprietary/lib/omx/libOmxAacEnc.so:system/lib/libOmxAacEnc.so \
    device/lge/swift/proprietary/lib/omx/libOmxAmrwbDec.so:system/lib/libOmxAmrwbDec.so \
    device/lge/swift/proprietary/lib/omx/libOmxMp3Dec.so:system/lib/libOmxMp3Dec.so \
    device/lge/swift/proprietary/lib/omx/libOmxVidEnc.so:system/lib/libOmxVidEnc.so \
    device/lge/swift/proprietary/lib/omx/libOmxAmrDec.so:system/lib/libOmxAmrDec.so \
    device/lge/swift/proprietary/lib/omx/libOmxEvrcDec.so:system/lib/libOmxEvrcDec.so \
    device/lge/swift/proprietary/lib/omx/libOmxMpeg4Dec.so:system/lib/libOmxMpeg4Dec.so \
    device/lge/swift/proprietary/lib/omx/libOmxWmaDec.so:system/lib/libOmxWmaDec.so \
    device/lge/swift/proprietary/lib/omx/libOmxAmrEnc.so:system/lib/libOmxAmrEnc.so \
    device/lge/swift/proprietary/lib/omx/libOmxEvrcEnc.so:system/lib/libOmxEvrcEnc.so \
    device/lge/swift/proprietary/lib/omx/libOmxQcelp13Enc.so:system/lib/libOmxQcelp13Enc.so \
    device/lge/swift/proprietary/lib/omx/libOmxWmvDec.so:system/lib/libOmxWmvDec.so

# Hardware properties 
PRODUCT_COPY_FILES += \
    frameworks/base/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml \
    frameworks/base/data/etc/android.hardware.camera.autofocus.xml:system/etc/permissions/android.hardware.camera.autofocus.xml \
    frameworks/base/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/base/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
    frameworks/base/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/base/data/etc/android.hardware.touchscreen.xml:system/etc/permissions/android.hardware.touchscreen.xml

# Camera proprietaries
PRODUCT_COPY_FILES += \
    device/lge/swift/proprietary/lib/camera/liboemcamera.so:system/lib/liboemcamera.so \
    device/lge/swift/proprietary/lib/camera/libmmjpeg.so:system/lib/libmmjpeg.so \
    device/lge/swift/proprietary/lib/camera/libmmipl.so:system/lib/libmmipl.so


# Other libraries and proprietary binaries
PRODUCT_COPY_FILES += \
  device/lge/swift/proprietary/bin/akmd2:system/bin/akmd2 \
#    vendor/lge/swift/proprietary/bin/hci_qcomm_init:system/bin/hci_qcomm_init \
#    device/lge/swift/prebuilt/init.qcom.bt.sh:system/bin/init.qcom.bt.sh \
#    device/lge/swift/ms3c_charger_offset.cfg:system/etc/ms3c_charger_offset.cfg \
#    device/lge/swift/ms3c_transformation.cfg:system/etc/ms3c_transformation.cfg \
#    device/lge/swift/AutoVolumeControl.txt:system/etc/AutoVolumeControl.txt \
#    device/lge/swift/AudioFilter.csv:system/etc/AudioFilter.csv \
#    vendor/lge/swift/proprietary/lib/liba2dp.so:system/lib/liba2dp.so \
#    vendor/lge/swift/proprietary/lib/libaudioeq.so:system/lib/libaudioeq.so \


#Adreno proprietary
PRODUCT_COPY_FILES += \
    device/lge/swift/proprietary/lib/egl/libGLESv1_CM_adreno200.so:system/lib/egl/libGLESv1_CM_adreno200.so \
    device/lge/swift/proprietary/lib/egl/libq3dtools_adreno200.so:system/lib/egl/libq3dtools_adreno200.so \
    device/lge/swift/proprietary/lib/egl/libEGL_adreno200.so:system/lib/egl/libEGL_adreno200.so \
    device/lge/swift/proprietary/lib/egl/libGLESv2_adreno200.so:system/lib/egl/libGLESv2_adreno200.so \
    device/lge/swift/proprietary/etc/firmware/yamato_pfp.fw:system/etc/firmware/yamato_pfp.fw \
    device/lge/swift/proprietary/etc/firmware/yamato_pm4.fw:system/etc/firmware/yamato_pm4.fw \
    device/lge/swift/proprietary/lib/libgsl.so:system/lib/libgsl.so

# Some files
PRODUCT_COPY_FILES += \
   device/lge/swift/files/media_profiles.xml:system/etc/media_profiles.xml \
   device/lge/swift/files/dhcpcd.conf:system/etc/dhcpcd/dhcpcd.conf \
   device/lge/swift/files/vold.fstab:system/etc/vold.fstab \
   device/lge/swift/files/wpa_supplicant.conf:system/etc/wifi/wpa_supplicant.conf 

# Keylayouts
PRODUCT_COPY_FILES += \
	device/lge/swift/prebuilt/swift_touchscreen.kcm.bin:system/usr/keychars/swift_touchscreen.kcm.bin \
	device/lge/swift/prebuilt/swift_touchscreen.kl:system/usr/keylayout/swift_touchscreen.kl \
	device/lge/swift/prebuilt/qwerty.kl:system/usr/keylayout/qwerty.kl 

# Bluetooth
PRODUCT_COPY_FILES += \
	device/lge/swift/proprietary/bluetooth/BCM4325D1_004.002.004.0262.0270.hcd:system/bin/BCM4325D1_004.002.004.0262.0270.hcd \
	device/lge/swift/proprietary/bluetooth/btld:system/bin/btld



# Wifi 
PRODUCT_COPY_FILES += \
	device/lge/swift/proprietary/wifi/rtecdc.bin:system/etc/wl/rtecdc.bin \
	device/lge/swift/proprietary/wifi/rtecdc-apsta.bin:system/etc/wl/rtecdc-apsta.bin \
	device/lge/swift/proprietary/wifi/nvram.txt:system/etc/wl/nvram.txt \
	device/lge/swift/proprietary/wifi/rtecdc-mfgtest.bin:system/etc/wl/rtecdc-mfgtest.bin 


$(call inherit-product, build/target/product/full_base.mk)




PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0
PRODUCT_NAME := swift
PRODUCT_DEVICE := swift
PRODUCT_MODEL := GT540
$(call inherit-product, device/common/gps/gps_eu_supl.mk)

PRODUCT_PROPERTY_OVERRIDES += \
    ro.tethering.kb_disconnect=1



