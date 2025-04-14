CC = arm-none-eabi-gcc

CPU = -mcpu=cortex-m4 -mthumb -mfloat-abi=softfp -mfpu=fpv4-sp-d16
OPT = -g -Og -gdwarf-2

DEFINES := \
DEBUG \
STM32L476xx \
USE_HAL_DRIVER \

DEFINES_FLAGS := $(addprefix -D,$(DEFINES))

INC_DIRS := \
./Core/Inc \
./Drivers/CMSIS/Device/ST/STM32L4xx/Include \
./Drivers/CMSIS/Include \
./Drivers/STM32L4xx_HAL_Driver/Inc \
./Drivers/STM32L4xx_HAL_Driver/Inc/Legacy \
./FreeRTOS/Source/include \
./FreeRTOS/Source/CMSIS_RTOS_V2 \
./FreeRTOS/Source/portable/GCC/ARM_CM4F \

INC_FLAGS := $(addprefix -I,$(INC_DIRS))

SECTIONS_FLAGS := -ffunction-sections -fdata-sections
DEPS_FLAGS := -MMD -MP

CFLAGS = $(CPU) $(OPT) $(DEFINES_FLAGS) $(INC_FLAGS) $(SECTIONS_FLAGS) -fstack-usage $(DEPS_FLAGS)
CFLAGS += -Wpedantic -Wall
# CFLAGS += -Werror

ASFLAGS = $(CPU) $(OPT)
# ASFLAGS += -Werror

LDFLAGS = -specs=nosys.specs -T$(LINKER_SCRIPT) -Wl,-Map,$(TARGET_EXEC).map,--no-warn-rwx-segment -Wl,--gc-sections $(CPU) $(OPT)

LINKER_SCRIPT := ./STM32L476RGTX_FLASH.ld

#####################################################

BUILD_DIR := ./Build
TARGET_EXEC := $(BUILD_DIR)/main

SRC_DIRS := \
./Core/Src \
./Core/Startup \
./Drivers/STM32L4xx_HAL_Driver/Src \
./FreeRTOS/Source \
./FreeRTOS/Source/portable/GCC/ARM_CM4F \
./FreeRTOS/Source/portable/MemMang \

# Find all the C and ASM files we want to compile
# Note the single quotes around the * expressions. The shell will incorrectly expand these otherwise, but we want to send the * directly to the find command.
SRCS := $(shell find $(SRC_DIRS) -name '*.c' -or -name '*.s')

# Prepends BUILD_DIR and appends .o to every src file
# As an example, ./your_dir/hello.cpp turns into ./build/./your_dir/hello.cpp.o
OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)

# String substitution (suffix version without %).
# As an example, ./build/hello.cpp.o turns into ./build/hello.cpp.d
DEPS := $(OBJS:.o=.d)

all: $(TARGET_EXEC).bin $(TARGET_EXEC).hex $(TARGET_EXEC).list

$(TARGET_EXEC).bin: $(TARGET_EXEC).elf
	@mkdir -p "$(dir $@)"
	arm-none-eabi-objcopy -O binary $< $@

$(TARGET_EXEC).hex: $(TARGET_EXEC).elf
	@mkdir -p "$(dir $@)"
	arm-none-eabi-objcopy -O ihex $< $@

$(TARGET_EXEC).list: $(TARGET_EXEC).elf
	@mkdir -p "$(dir $@)"
	@echo ' '
	arm-none-eabi-objdump -h -S $< > "$@"
	@echo 'Finished building target: $@'
	@echo ' '

$(TARGET_EXEC).elf: $(OBJS)
	@mkdir -p "$(dir $@)"
	$(CC) $^ $(LDFLAGS) -o $@
	@echo 'Finished building target: $@'
	@echo ' '
	arm-none-eabi-size $@
	@echo ' '

$(BUILD_DIR)/%.c.o $(BUILD_DIR)/%.su: %.c
	@mkdir -p "$(dir $@)"
	$(CC) $< -c $(CFLAGS) -o $@

$(BUILD_DIR)/%.s.o: %.s
	@mkdir -p "$(dir $@)"
	$(CC) $< -c $(ASFLAGS) -o $@

clean:
	rm -r $(BUILD_DIR)

.PHONY: all clean

# Include the .d makefiles. The - at the front suppresses the errors of missing
# Makefiles. Initially, all the .d files will be missing, and we don't want those
# errors to show up.
-include $(DEPS)