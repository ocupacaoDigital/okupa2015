all:	flash

firmware:
	@echo "firmware.elf"
	@msp430-gcc -Os -mmcu=msp430g2553 main.c -o firmware.elf

flash:	firmware
	mspdebug rf2500 "prog firmware.elf"

clean:
	@if [ -e firmware.elf ]; then echo "firmware.elf" && rm firmware.elf; fi
