THEOS_DEVICE_IP = 192.168.60.40
ARCHS = armv7 arm64
TARGET = iphone:latest:8.0

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = iOSRETargetApp
iOSRETargetApp_FILES = main.m MXAppDelegate.m MXRootViewController.mm
iOSRETargetApp_FRAMEWORKS = UIKit CoreGraphics

include $(THEOS_MAKE_PATH)/application.mk

after-install::
	install.exec "su mobile -c uicache"
