# This file contains core defines.
# User should provide:
# LINKER_SCRIPT := path to linker script file
# TARGET_BINARY := path to binary file without extension

CC = arm-none-eabi-gcc

OPT = -g -Og -gdwarf-2
CPU = -mcpu=cortex-m4 -mthumb -mfloat-abi=softfp -mfpu=fpv4-sp-d16

DEFINES := STM32L476xx
DEFINES_FLAGS := $(addprefix -D,$(DEFINES))

# Add directiories to be searched for header files by the GCC
INC_DIRS := sys/CMSIS
# Add a prefix to INC_DIRS. So moduleA would become -ImoduleA. GCC understands this -I flag
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

CFLAGS = $(CPU) $(OPT) $(DEFINES_FLAGS) $(INC_FLAGS)
CFLAGS += -Wpedantic -Wall
# CFLAGS += -Werror

ASFLAGS = $(CPU) $(OPT)
# ASFLAGS += -Werror

LDFLAGS = -specs=nosys.specs -T$(LINKER_SCRIPT) -Wl,-Map,$(TARGET_BINARY).map,--no-warn-rwx-segment $(CPU) $(OPT)