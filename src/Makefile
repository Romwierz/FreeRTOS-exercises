# CC = arm-none-eabi-gcc
# # Copies a binary file, possibly transforming it in the process
# # w tym przypadku przekształca plik elf w plik bin
# OBJCPY = arm-none-eabi-objcopy

# OPT = -g -Og -gdwarf-2

# CPU = -mcpu=cortex-m4 -mthumb -mfloat-abi=softfp -mfpu=fpv4-sp-d16

# CFLAGS = $(CPU) $(OPT) -Werror -Wall -Wpedantic
# # kompilacja plików assemblerowych
# ASFLAGS = $(CPU) $(OPT) -Werror
# # wszystkie flagi przekazywane do kompilatora na etapie linkowania
# LDFLAGS = $(CPU) $(OPT) -specs=nosys.specs -Wl,--fatal-warnings -TSTM32L476RGTX_FLASH.ld

OUT_DIR = out

LINKER_SCRIPT := sys/STM32L476RGTX_FLASH.ld
TARGET_BINARY := $(OUT_DIR)/main

include sys/sys.mk

SRCS = \
sys/syscalls.c \
main.c \
sys/startup_stm32l476rgtx.s \
my_math.c

OBJS := $(SRCS:%=$(OUT_DIR)/%.o)

all: $(TARGET_BINARY).bin $(TARGET_BINARY).hex $(TARGET_BINARY).list

$(TARGET_BINARY).bin: $(TARGET_BINARY).elf
	@mkdir -p "$(dir $@)"
	arm-none-eabi-objcopy -O binary $< $@

$(TARGET_BINARY).hex: $(TARGET_BINARY).elf
	@mkdir -p "$(dir $@)"
	arm-none-eabi-objcopy -O ihex $< $@

$(TARGET_BINARY).list: $(TARGET_BINARY).elf
	@mkdir -p "$(dir $@)"
	arm-none-eabi-objdump -h -S $(TARGET_BINARY).elf > "$(TARGET_BINARY).list"

$(TARGET_BINARY).elf: $(OBJS)
	@mkdir -p "$(dir $@)"
	$(CC) $(LDFLAGS) $^ -o $@
	arm-none-eabi-size $@

$(OUT_DIR)/%.c.o: %.c
	@mkdir -p "$(dir $@)"
	$(CC) -c $(CFLAGS) $< -o $@

$(OUT_DIR)/%.s.o: %.s
	@mkdir -p "$(dir $@)"
	$(CC) -c $(ASFLAGS) $< -o $@

clean:
	@rm -rf $(OUT_DIR)

# all nie będzie traktowany jako plik, tylko jako polecenie zapisane w tym pliku
.PHONY: all clean