#!/bin/bash

echo "$ msp430-gcc -mmcu=msp430g2553 -o main.elf main.c"
echo ""
msp430-gcc -mmcu=msp430g2553 -o main.elf main.c
echo "$ mspdebug rf2500"
echo ""
mspdebug rf2500