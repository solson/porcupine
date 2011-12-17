CLAY := clay
QEMU := qemu-system-i386

LDFLAGS := -melf_i386 -nostdlib -g
ASFLAGS := -felf32 -g

STAGE2 := /boot/grub/stage2_eltorito

CLAYFILES := $(shell find "src" -name "*.clay")
ASMFILES := $(shell find "src" -name "*.asm")
ASMOBJFILES := $(patsubst %.asm,%.o,$(ASMFILES))

.PHONY: all clean bochs bochs-dbg

all: porcupine.iso

bochs: porcupine.iso
	@bochs -qf .bochsrc

bochs-dbg: porcupine.iso
	@bochs -qf .bochsrc-dbg

qemu: porcupine.iso
	@$(QEMU) -cdrom $< -net none

porcupine.iso: porcupine.exe isofs/boot/grub/stage2_eltorito isofs/boot/grub/menu.lst
	@mkdir -p isofs/system
	cp $< isofs/system
	genisoimage -R -b boot/grub/stage2_eltorito -no-emul-boot -boot-load-size 4 -boot-info-table -input-charset utf-8 -o $@ isofs

porcupine.exe: ${ASMOBJFILES} src/porcupine.o
	${LD} ${LDFLAGS} -T src/linker.ld -o $@ ${ASMOBJFILES} src/porcupine.o

src/porcupine.o: src/porcupine.s
	as --32 -g -o $@ src/porcupine.s

src/porcupine.s: ${CLAYFILES}
	${CLAY} -Isrc -no-exceptions -shared -Dclay.DisableAssertions -target i386-pc-linux-gnu -S -o $@ src/boot/boot.clay

%.o: %.asm
	nasm ${ASFLAGS} -o $@ $<

isofs/boot/grub/stage2_eltorito:
	mkdir -p isofs/boot/grub
	cp ${STAGE2} $@

clean:
	 $(RM) -r $(wildcard $(ASMOBJFILES) src/porcupine.s src/porcupine.o porcupine.exe porcupine.iso isofs/system/porcupine.exe)
