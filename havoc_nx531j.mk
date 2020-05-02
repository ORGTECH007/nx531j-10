#
# Copyright (C) 2018 The Mokee Open Source Project
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

# Boot animation
TARGET_SCREEN_HEIGHT := 1080
TARGET_SCREEN_WIDTH := 1920

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit some common havoc stuff.
$(call inherit-product, vendor/havoc/config/common_full_phone.mk)

# Inherit device configuration
$(call inherit-product, device/nubia/nx531j/msm8996.mk)

# Device identifier. This must come after all inclusions
PRODUCT_NAME := havoc_nx531j
PRODUCT_DEVICE := nx531j
PRODUCT_BRAND := nubia
PRODUCT_MODEL := nx531j
PRODUCT_MANUFACTURER := nubia

PRODUCT_GMS_CLIENTID_BASE := android-nubia

TARGET_VENDOR_PRODUCT_NAME := NX531J
TARGET_VENDOR_DEVICE_NAME := NX531J

PRODUCT_BUILD_PROP_OVERRIDES += TARGET_DEVICE=NX531J PRODUCT_NAME=NX531J PRODUCT_MODEL=NX531J

# Official HavocOS
HAVOC_BUILD_TYPE := Stable

# Build Fingerprint
PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="coral-user 10 QQ2A.200405.005 6254899 release-keys"

# Build Fingerprint
PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="coral-user 10 QQ2A.200405.005 6254899 release-keys"

#Build FP to be picked by both system and vendor
BUILD_FINGERPRINT := "google/coral/coral:10/QQ2A.200405.005/6254899:user/release-keys"


PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.fingerprint=$(BUILD_FINGERPRINT)