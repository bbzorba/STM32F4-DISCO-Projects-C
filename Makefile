# STM32 Multi-Project Makefile
# Set PROJECT to the subfolder name (e.g., LED_Blink)

PROJECT=Projects/LCD_Screen
SRCDIR=$(PROJECT)/src
INCDIR=$(PROJECT)/inc
BUILDDIR=$(PROJECT)/build
LINKER=$(PROJECT)/linker.ld

# Toolchain
CC=arm-none-eabi-gcc
LD=arm-none-eabi-gcc
OBJCOPY=arm-none-eabi-objcopy
SIZE=arm-none-eabi-size
OPENOCD=openocd

# Source and object files
SRCS=$(wildcard $(SRCDIR)/*.c) \
  $(wildcard Drivers/STM32F4xx_HAL_Driver/*.c)
OBJS=$(SRCS:.c=.o)

# Flags
CFLAGS=-mcpu=cortex-m4 -mthumb -O2 -Wall -ffreestanding -nostdlib \
  -IDrivers/STM32F4xx_HAL_Driver \
  -IDrivers/CMSIS \
  -I$(INCDIR) -g
LDFLAGS=-T$(LINKER) -nostdlib -ffreestanding -mcpu=cortex-m4 -mthumb -Wl,-Map=$(PROJECT)/main.map

# Output files
TARGET=$(PROJECT)/main
ELF=$(TARGET).elf
BIN=$(TARGET).bin
HEX=$(TARGET).hex
MAP=$(TARGET).map

# Default target
all: $(ELF) $(BIN) $(HEX) size

$(ELF): $(OBJS) $(LINKER)
	$(LD) $(LDFLAGS) -o $@ $(OBJS)

$(BIN): $(ELF)
	$(OBJCOPY) -O binary $< $@

$(HEX): $(ELF)
	$(OBJCOPY) -O ihex $< $@

size: $(ELF)
	$(SIZE) $<

$(SRCDIR)/%.o: $(SRCDIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	cd $(SRCDIR) && del /Q *.o
	cd $(PROJECT) && del /Q main.elf main.bin main.hex main.map

flash: $(ELF)
	$(OPENOCD) -f interface/stlink.cfg -f target/stm32f4x.cfg -c "program $< verify reset exit"

debug: $(ELF)
	@echo "Launch VS Code debug (Cortex-Debug) with $(ELF) and OpenOCD."
	@echo "Ensure .vscode/launch.json is configured for Cortex-Debug in $(PROJECT)."

.PHONY: all clean flash debug size