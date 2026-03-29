#!/bin/sh

# add the ARM cross toolchain to your path
# for aarch64
export PATH=/home/faisal/Documents/OSTEP/arm-gnu-toolchain-15.2.rel1-x86_64-aarch64-none-elf/bin:$PATH

# Build Kernel
clear

echo Building xv6 for ARM 64 bit

#make -j`getconf _NPROCESSORS_ONLN`
make
