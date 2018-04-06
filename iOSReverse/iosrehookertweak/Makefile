THEOS_DEVICE_IP = 192.168.60.40
ARCHS = armv7 arm64
TARGET = iphone:latest:8.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = iOSREHookerTweak
iOSREHookerTweak_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 iOSRETargetApp"
