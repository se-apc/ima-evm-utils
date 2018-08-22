#!/bin/sh

source /opt/poky/rzn1/environment-setup-armv7vehf-vfpv4d16-poky-linux-gnueabi

bash autogen.sh
./configure --host=arm-poky-linux-gnueabi --disable-debug
make
echo "LDFLAGS = $LDFLAGS"
target_alias=lces2
#bash autogen.sh
#EXTRA_OPTS=--gc-sections 

LDFLAGS="-Wl,-L${SDKTARGETSYSROOT}/usr/lib/ $LDFLAGS -Wl,--gc-sections"
#$CC -static -Os -o evmctl.static -include config.h src/evmctl.c src/libimaevm.c -lcrypto -lkeyutils -ldl
echo "$CC -static -Os -ffunction-sections -fdata-sections $LDFLAGS -o evmctl.static -include config.h src/evmctl.c src/libimaevm.c -lcrypto -lkeyutils -ldl"
#${CC} -static -Os -ffunction-sections -fdata-sections $LDFLAGS -o evmctl.static -include config.h src/evmctl.c src/libimaevm.c -lcrypto -lkeyutils -ldl
${CC} -static -Os -ffunction-sections -fdata-sections $LDFLAGS -o evmctl.static -include config.h src/evmctl.c src/libimaevm.c -lcrypto -lkeyutils -ldl -pthread -limaevm -lssl
${STRIP} ./evmctl.static
#-limaevm
#-lssl 

#dynamically linked evmctl = 90616
#statically linked evmctl.static = 2.8M

#libcrypto = 1.4M
#libc = 1.2M
#libkeyutils1.5 =  13.8K
#libdl = 90K
#6336 May 23 10:11 /opt/poky/rzn1/sysroots/armv7vehf-vfpv4d16-poky-linux-gnueabi/usr/bin/keyctl
#
# We probably need evmctl import in the form of evmctl_import exec:
# ima_id=`keyctl newring _ima @u`
# evmctl import /etc/keys/pubkey_ima.pem $ima_id
# evm_id=`keyctl newring _evm @u`
# evmctl import /etc/keys/pubkey_evm.pem $evm_
#
# Creation of initramfs:
#
# copy_exec /etc/keys/evm-key
# copy_exec /etc/keys/pubkey_evm.pem
# copy_exec /etc/ima_policy
# copy_exec /bin/keyctl
# copy_exec /usr/bin/evmctl /bin/evmctl
