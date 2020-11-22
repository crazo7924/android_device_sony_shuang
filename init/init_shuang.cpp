/*
   Copyright (c) 2016, The CyanogenMod Project
                 2017-20, The LineageOS Project

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions are
   met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above
      copyright notice, this list of conditions and the following
      disclaimer in the documentation and/or other materials provided
      with the distribution.
    * Neither the name of The Linux Foundation nor the names of its
      contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.

   THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
   WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
   ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
   BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
   BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
   WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
   OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
   IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <android-base/logging.h>
#include <android-base/properties.h>
#include <android-base/strings.h>
#include <android-base/file.h>

#define _REALLY_INCLUDE_SYS__SYSTEM_PROPERTIES_H_
#include <sys/_system_properties.h>

#include "property_service.h"
#include "init_shuang.h"

using android::base::GetProperty;
using android::init::property_set;

#define LTA_LABEL "/lta-label"

enum { D2004, D2005, D2104, D2105, D2114 };

void property_override(char const prop[], char const value[], bool add)
{
    auto pi = (prop_info *) __system_property_find(prop);

    if (pi != nullptr) {
        __system_property_update(pi, value, strlen(value));
    } else if (add) {
        __system_property_add(prop, strlen(prop), value, strlen(value));
    }
}

void import_kernel_cmdline(const std::function<void(const std::string&, const std::string&)>& fn) {
    std::string cmdline;
    android::base::ReadFileToString("/proc/cmdline", &cmdline);

    for (const auto& entry : android::base::Split(android::base::Trim(cmdline), " ")) {
        std::vector<std::string> pieces = android::base::Split(entry, "=");
        if (pieces.size() == 2) {
            fn(pieces[0], pieces[1]);
        }
    }
}

static int model_number_from_ltalabel() {
    DIR* dir;
    struct dirent* dp;
    int rc = 0;

    // Open '/lta-label' (like 'cd /lta-label')
    dir = opendir(LTA_LABEL);
    if (dir) {
        // Show all files inside '/lta-label' (like 'ls')
        while ((dp = readdir(dir)) != NULL) {
            // Only show html files (like 'grep html')
            if (strstr(dp->d_name, ".html")) {
                // Check one of supported models (like 'grep *model*')
                if (strstr(dp->d_name, "D2004")) {
                    rc = D2004;
                } else if (strstr(dp->d_name, "D2005")) {
                    rc = D2005;
                } else if (strstr(dp->d_name, "D2104")) {
                    rc = D2104;
                } else if (strstr(dp->d_name, "D2105")) {
                    rc = D2105;
                } else if (strstr(dp->d_name, "D2114")) {
                    rc = D2114;
                };
            };
        };
        // Close '/lta-label' (like 'cd /')
        closedir(dir);
    };
    return rc;
}

static void import_kernel_nv(const std::string& key, const std::string& value) {
    if (key.empty()) {
        return;
    };

    if (key == "oemandroidboot.phoneid") {
        // Dual Sim variant contains two IMEIs separated by comma
        if ((count(value.begin(), value.end(), ',')) > 0) {
            property_set("persist.radio.multisim.config", "dsds");
            property_set("persist.radio.dont_use_dsd", "true");
            property_set("ro.telephony.ril.config", "simactivation");
            property_set("ro.telephony.default_network", "3,1");
        } else {
            property_set("ro.telephony.default_network", "3");
        };
    };
}

void vendor_load_properties() {
    std::string device;

    // Set DualSIM based in cmdline
    import_kernel_cmdline(import_kernel_nv);

    // Search model_number from '/lta-label'
    switch (model_number_from_ltalabel()) {
        case D2004:
            property_override("ro.product.device", "D2004");
            property_override("ro.product.model", "D2004");
            property_override(
                "ro.build.description",
                "D2004-user 4.4.2 20.1.A.2.19 7Pd_Xw release-keys");
            property_override("ro.build.fingerprint",
                              "Sony/D2004/D2004:4.4.2/"
                              "20.1.A.2.19/7Pd_Xw:user/"
                              "release-keys");
            break;
        case D2005:
            property_override("ro.product.device", "D2005");
            property_override("ro.product.model", "D2005");
            property_override(
                "ro.build.description",
                "D2005-user 4.4.2 20.1.A.2.19 7Pd_Xw release-keys");
            property_override("ro.build.fingerprint",
                              "Sony/D2005/D2005:4.4.2/"
                              "20.1.A.2.19/7Pd_Xw:user/"
                              "release-keys");
            break;
        case D2104:
            property_override("ro.product.device", "D2104");
            property_override("ro.product.model", "D2104");
            property_override(
                "ro.build.description",
                "D2104-user 4.4.2 20.1.B.2.29 4rd_Xw release-keys");
            property_override("ro.build.fingerprint",
                              "Sony/D2104/D2104:4.4.2/"
                              "20.1.B.2.29/4rd_Xw:user/"
                              "release-keys");
            break;
        case D2105:
            property_override("ro.product.device", "D2105");
            property_override("ro.product.model", "D2105");
            property_override(
                "ro.build.description",
                "D2105-user 4.4.2 20.1.B.2.29 4rd_Xw release-keys");
            property_override("ro.build.fingerprint",
                              "Sony/D2105/D2105:4.4.2/"
                              "20.1.B.2.29/4rd_Xw:user/"
                              "release-keys");
            break;
        case D2114:
            property_override("ro.product.device", "D2114");
            property_override("ro.product.model", "D2114");
            property_override(
                "ro.build.description",
                "D2114-user 4.4.2 20.1.B.2.30 4bd_Xw release-keys");
            property_override("ro.build.fingerprint",
                              "Sony/D2114/D2114:4.4.2/"
                              "20.1.B.2.30/4bd_Xw:user/"
                              "release-keys");
            break;
        default:
            break;
    };

    // Get model just for log
    device = GetProperty("ro.product.device", "");
    LOG(ERROR) << "Setting build properties for " << device <<  " device" << std::endl;
}
