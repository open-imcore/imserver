RELEASE_BUILD_ARGS=--configuration release --arch arm64 --arch x86_64
DEBUG_BUILD_ARGS=--configuration debug
BUILD_ARGS?=$(DEBUG_BUILD_ARGS)
BINARY_PATH=$(shell swift build $(BUILD_ARGS) --show-bin-path)

CODESIGN_IDENTITY?="-"
ENTITLEMENTS_PATH=$(PWD)/Sources/imserver/imserver.entitlements
KC_PASSWORD?=""
KC_PATH?=$(HOME)/Library/Keychains/login.keychain

sign:
	codesign -fs $(CODESIGN_IDENTITY) --keychain "$(KC_PATH)" --entitlements $(ENTITLEMENTS_PATH) $(BINARY_PATH)/imserver

ci-sign:
	security unlock-keychain -p $(KC_PASSWORD) ci.keychain
	make sign

build:
	swift build $(BUILD_ARGS)
	
product-path:
	echo $(BINARY_PATH)/imserver
	
all: build sign
