LOCAL_PATH := $(call my-dir)
define walk
  $(wildcard $(1)) $(foreach e, $(wildcard $(1)/*), $(call walk, $(e)))
endef

include $(CLEAR_VARS)
LOCAL_MODULE           := lspd
LOCAL_C_INCLUDES       := $(LOCAL_PATH)/include $(LOCAL_PATH)/src
FILE_LIST              := $(filter %.cpp, $(call walk, $(LOCAL_PATH)/src))
LOCAL_SRC_FILES        := $(FILE_LIST:$(LOCAL_PATH)/%=%) api/config.cpp
LOCAL_STATIC_LIBRARIES := cxx riru yahfa dobby dex_builder
ifeq ($(API), riru)
LOCAL_SRC_FILES        += api/riru_main.cpp
else ifeq ($(API), zygisk)
LOCAL_SRC_FILES        += api/zygisk_main.cpp
endif
LOCAL_CFLAGS           += -DINJECTED_AID=${INJECTED_AID}
LOCAL_LDLIBS           := -llog
include $(BUILD_SHARED_LIBRARY)

$(LOCAL_PATH)/api/config.cpp : FORCE
	$(file > $@,#include "config.h")
	$(file >> $@,namespace lspd {)
	$(file >> $@,const int versionCode = ${VERSION_CODE};)
	$(file >> $@,const int apiVersion = ${API_VERSION};)
	$(file >> $@,const char* const versionName = "${VERSION_NAME}";)
	$(file >> $@,const char* const moduleName = "${MODULE_NAME}";)
	$(file >> $@,})
FORCE: ;
