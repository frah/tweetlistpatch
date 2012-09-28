include theos/makefiles/common.mk

TWEAK_NAME = TweetListPatch
TweetListPatch_FILES = Tweak.xm
TweetListPatch_FRAMEWORKS = UIKit Twitter

include $(THEOS_MAKE_PATH)/tweak.mk
