#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017 The LineageOS Project
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

set -e

# Required!
export DEVICE=nx531j
export VENDOR=nubia

export DEVICE_BRINGUP_YEAR=2019

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

MK_ROOT="${MY_DIR}/../../.."

HELPER="${MK_ROOT}/vendor/havoc/build/tools/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

function blob_fixup() {
    case "${1}" in
    vendor/bin/imsrcsd)
        patchelf --add-needed "libbase_shim.so" "${2}"
        ;;
    # Patch blobs for VNDK
    vendor/lib/libmmcamera2_stats_modules.so)
        sed -i "s|libgui.so|libfui.so|g" "${2}"
        sed -i "s|libandroid.so|libcamshim.so|g" "${2}"
        ;;

    # Patch blobs for VNDK
    vendor/lib/libmmcamera_ppeiscore.so)
        sed -i "s|libgui.so|libfui.so|g" "${2}"
        ;;

    # Patch blobs for VNDK
    vendor/lib/libmpbase.so)
        patchelf --remove-needed "libandroid.so" "${2}"
        ;;
    esac
}

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true
SECTION=
KANG=

while [ "$1" != "" ]; do
    case "$1" in
        -n | --no-cleanup )     CLEAN_VENDOR=false
                                ;;
        -k | --kang)            KANG="--kang"
                                ;;
        -s | --section )        shift
                                SECTION="$1"
                                CLEAN_VENDOR=false
                                ;;
        * )                     SRC="$1"
                                ;;
    esac
    shift
done

if [ -z "${SRC}" ]; then
    SRC=adb
fi

# Initialize the helper for device
setup_vendor "${DEVICE}" "${VENDOR}" "${MK_ROOT}" true "${CLEAN_VENDOR}"

extract "${MY_DIR}"/proprietary-files.txt "${SRC}" "${SECTION}"


DEVICE_BLOB_ROOT="${MK_ROOT}"/vendor/"${VENDOR}"/"${DEVICE}"/proprietary

# Camera data
for CAMERA_LIB in libmmcamera2_cpp_module.so libmmcamera2_iface_modules.so libmmcamera2_imglib_modules.so libmmcamera2_mct.so libmmcamera2_pproc_modules.so libmmcamera2_sensor_modules.so libmmcamera2_stats_algorithm.so libmmcamera2_stats_modules.so libmmcamera_dbg.so libmmcamera_hvx_grid_sum.so libmmcamera_imglib.so libmmcamera_isp_mesh_rolloff44.so libmmcamera_pdafcamif.so libmmcamera_pdaf.so libmmcamera_tintless_algo.so libmmcamera_tintless_bg_pca_algo.so libmmcamera_tuning.so; do
    sed -i "s|/data/misc/camera|/data/vendor/qcam|g" "${DEVICE_BLOB_ROOT}"/vendor/lib/${CAMERA_LIB}
done

for CAMERA_LIB64 in libmmcamera2_q3a_core.so libmmcamera2_stats_algorithm.so libmmcamera_dbg.so libmmcamera_tintless_algo.so libmmcamera_tintless_bg_pca_algo.so; do
    sed -i "s|/data/misc/camera|/data/vendor/qcam|g" "${DEVICE_BLOB_ROOT}"/vendor/lib64/${CAMERA_LIB64}
done

# Camera socket
sed -i "s|/data/misc/camera/cam_socket|/data/vendor/qcam/cam_socket|g" "$DEVICE_BLOB_ROOT"/vendor/bin/mm-qcamera-daemon

# Fingerprint blobs
sed -i "s|/data/misc/stargate|/data/vendor/stargate|g" "${DEVICE_BLOB_ROOT}"/vendor/lib64/hw/fingerprint.msm8996.so
sed -i "s|/data/misc/stargate|/data/vendor/stargate|g" "${DEVICE_BLOB_ROOT}"/vendor/lib64/lib_fpc_tac_shared.so



"${MY_DIR}"/setup-makefiles.sh
