#! /bin/sh

#
# Build for iOS 64bit-ARM variants and iOS Simulator
# - Place the script at project root
# - Customize MIN_IOS_VERSION and other flags as needed
#
# Test Environment
# - macOS 12+
# - iOS 13.1
# - Xcode 11.1
#

isSubPath(){
	if [[ $(realpath --relative-base="$1" -- "$2")  =~ ^/ ]]
	then printf '%s\n' "$2 NOT subpath of $1"
	else printf '%s\n' "$2 subpath of $1"
	fi
}

VAR=$PROJECT_NAME
[ ! "${PWD:0:${#VAR}}" = "$VAR" ] && echo "************** $VAR *************" || echo  "************** $PWD *************"


Build() {
    # Ensure -fembed-bitcode builds, as workaround for libtool macOS bug
    export MACOSX_DEPLOYMENT_TARGET="12.0"
    # Get the correct toolchain for target platforms
    export CC=$(xcrun --find --sdk "${SDK}" clang)
    export CXX=$(xcrun --find --sdk "${SDK}" clang++)
    export CPP=$(xcrun --find --sdk "${SDK}" cpp)
    export CFLAGS="${HOST_FLAGS} ${OPT_FLAGS}"
    export CXXFLAGS="${HOST_FLAGS} ${OPT_FLAGS}"
    export LDFLAGS="${HOST_FLAGS}"

	VAR=$PWD
	[ ! "${PWD:0:${#VAR}}" = "$VAR" ] && echo "************** $VAR *************" || echo  "************** $PWD *************"

    EXEC_PREFIX="${PLATFORMS}/${PLATFORM}"
	test ./autogen.sh || echo "************** missing autogen.sh *************" && true;
	test configure.ac && ./autogen.sh || echo "************** missing configure.ac *************" && true;
    ./configure \
        --host="${CHOST}" \
        --prefix="${PREFIX}" \
        --exec-prefix="${EXEC_PREFIX}" #\
        #--enable-static \
        #--with-gui=no \
        #--disable-shared  # Avoid Xcode loading dylibs even when staticlibs exist

    make clean
    mkdir -p "${PLATFORMS}" &> /dev/null
    # make V=1 -j"${MAKE_JOBS}" --debug=j -C depends
    make V=1 -j"${MAKE_JOBS}" --debug=j
    # make deploy
}

Install(){
LIB_NAME=`find ${PLATFORMS}/. -iname *.a`
# install src/*.a "${PLATFORMS}/${PLATFORM}/lib"
}

Lipo(){
for LIB_NAME in libbitcoin_cli.a libbitcoin_node.a libbitcoin_common.a libbitcoin_wallet.a libbitcoin_consensus.a
do
    echo ${LIB_NAME}
    lipo -create -output "${UNIVERSAL}/bitcoin.a" "${PLATFORMS}/${PLATFORM_ARM}/lib/${LIB_NAME}" "${PLATFORMS}/${PLATFORM_X86}/lib/${LIB_NAME}"
done
}

echo "macos universal build..."

# Locations
ScriptDir="$( cd "$( dirname "$0" )" && pwd)"
echo $ScriptDir
cd - &> /dev/null
PREFIX="${ScriptDir}"/share/macos
PLATFORMS="${PREFIX}"/platforms
UNIVERSAL="${PREFIX}"/universal

# Compiler options
OPT_FLAGS="-O3 -g3 -fembed-bitcode"
MAKE_JOBS=8
MIN_IOS_VERSION=15.6.1

# Build for platforms
SDK="iphoneos"
PLATFORM="arm"
PLATFORM_ARM=${PLATFORM}
ARCH_FLAGS="-arch arm64" #-arch arm64e -arch aarch64"
HOST_FLAGS="${ARCH_FLAGS} -miphoneos-version-min=${MIN_IOS_VERSION} -isysroot $(xcrun --sdk ${SDK} --show-sdk-path)"
CHOST="arm-apple-darwin"
Build
mkdir -p "${PLATFORMS}/${PLATFORM_ARM}/lib"
## Install

SDK="iphoneos"
#PLATFORM="arm"
PLATFORM="x86_64"
PLATFORM_X86=${PLATFORM}
ARCH_FLAGS="-arch x86_64"
HOST_FLAGS="${ARCH_FLAGS} -miphoneos-version-min=${MIN_IOS_VERSION} -isysroot $(xcrun --sdk ${SDK} --show-sdk-path)"
CHOST="x86_64-apple-darwin"
#Build
mkdir -p "${PLATFORMS}/${PLATFORM_X86}/lib"
## Install

# Create universal binary
mkdir -p "${PLATFORMS}/${UNIVERSAL}/lib"
exit

# for value in libtest_util.a libtest_fuzz.a libbitcoin_cli.a libbitcoin_util.a libbitcoin_node.a libbitcoin_common.a libbitcoin_wallet.a libbitcoin_consensus.a libbitcoin_wallet_tool.a libminisketch.a

#do
 #   echo $value
#done
#libtest_util.a
#libtest_fuzz.a
#libbitcoin_cli.a
#libbitcoin_util.a
#libbitcoin_node.a
#libbitcoin_common.a
#libbitcoin_wallet.a
#libbitcoin_consensus.a
#libbitcoin_wallet_tool.a
#minisketch/libminisketch.a
# lipo -create -output "${UNIVERSAL}/${LIB_NAME}" "${PLATFORMS}/${PLATFORM_ARM}/lib/${LIB_NAME}" "${PLATFORMS}/${PLATFORM_ISIM}/lib/${LIB_NAME}"
echo ${LIB_NAME}
echo "BYE"