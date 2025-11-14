# Makefile for building a 512-byte BIOS boot sector and a 1.44MB floppy image
# Requirements: nasm, qemu (to run), dd

NASM := nasm
QEMU := qemu-system-i386
DD := dd

ASM := src/boot/boot.asm
BOOTBIN := boot.bin
IMG := gozos.img
BS := 512
COUNT := 2880    # 1.44MB floppy = 512 * 2880

.PHONY: all run clean bootimg

all: $(IMG)

$(BOOTBIN): $(ASM)
	@echo "Assembling $< -> $@"
	$(NASM) -f bin $< -o $@

$(IMG): $(BOOTBIN)
	@echo "Creating $(IMG) (1.44MB) and writing $(BOOTBIN) as boot sector"
	@if [ -f $(IMG) ]; then rm -f $(IMG); fi
	$(DD) if=/dev/zero of=$(IMG) bs=$(BS) count=$(COUNT) status=none
	$(DD) if=$(BOOTBIN) of=$(IMG) conv=notrunc status=none
	@echo "Image $(IMG) ready"

run: $(IMG)
	@echo "Starting QEMU..."
	$(QEMU) -fda $(IMG) -boot a -m 32M

clean:
	@rm -f $(BOOTBIN) $(IMG)
	@echo "Cleaned"

.PHONY: help
help:
	@echo "Usage: make [all|run|clean]"
	@echo "  all   - build $(IMG) (default)"
	@echo "  run   - run the built image in QEMU (requires qemu)"
	@echo "  clean - remove generated files"

