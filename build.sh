#!/bin/bash

mkdir -p build

beebasm -i src/RAMMaster.asm -v -o build/RAMMaster.rom | tee build/RAMMaster.lst

md5sum build/RAMMaster.rom
