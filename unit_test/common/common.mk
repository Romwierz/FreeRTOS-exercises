COLOR_GREEN = \033[32m
COLOR_RESET = \033[0m

LINKER_SCRIPT := ../../src/sys/STM32L476RGTX_FLASH.ld

# definy podane do kompilatora (zamiast w pliku .c/.h)
UNITY_FLAGS = -DUNITY_INCLUDE_CONFIG_H -DUNITY_FIXTURE_NO_EXTRAS

# Directories
SRC_DIR = ../../src
SYS_DIR = ../../src/sys
COMMON_DIR = ../common
OUT_DIR = out

OUT_SRC_DIR = $(OUT_DIR)/src
OUT_SYS_DIR = $(OUT_DIR)/sys
OUT_COMMON_DIR = $(OUT_DIR)/common
OUT_TEST_DIR = $(OUT_DIR)/test

TARGET_BINARY := $(OUT_DIR)/$(TARGET)

include ../../src/sys/sys.mk

# Object files
SRC_OBJS := $(patsubst $(SRC_DIR)/%,$(OUT_SRC_DIR)/%.o,$(SRC_FILES))
SYS_OBJS := $(patsubst $(SYS_DIR)/%,$(OUT_SYS_DIR)/%.o,$(SYS_FILES))
COMMON_OBJS := $(patsubst $(COMMON_DIR)/%,$(OUT_COMMON_DIR)/%.o,$(COMMON_FILES))
TEST_OBJS := $(patsubst %,$(OUT_TEST_DIR)/%.o,$(TEST_FILES))

OBJS := $(SRC_OBJS) $(SYS_OBJS) $(COMMON_OBJS) $(TEST_OBJS)

all:  $(TARGET_BINARY).bin

$(TARGET_BINARY).bin: $(TARGET_BINARY).elf
	@ printf "$(COLOR_GREEN)Creating binary from ELF...$(COLOR_RESET)\n"
	@ if not exist "$(dir $@)" mkdir "$(dir $@)"
# @ mkdir -p $(dir $@)
	arm-none-eabi-objcopy -O binary $< $@

$(TARGET_BINARY).elf: $(OBJS)
	@ printf "$(COLOR_GREEN)Linking object files...$(COLOR_RESET)\n"
	@ if not exist "$(dir $@)" mkdir "$(dir $@)"
# @ mkdir -p $(dir $@)
	$(CC) $(LDFLAGS) $^ -o $@
	arm-none-eabi-size $@

$(OUT_SRC_DIR)/%.c.o: $(SRC_DIR)/%.c
	@ printf "$(COLOR_GREEN)Compiling .c file...$(COLOR_RESET)\n"
	@ if not exist "$(dir $@)" mkdir "$(dir $@)"
# @ mkdir -p $(dir $@)
	$(CC) -c $(CFLAGS) $(INC) -o $@ $<

$(OUT_SRC_DIR)/%.s.o: $(SRC_DIR)/%.s
	@ printf "$(COLOR_GREEN)Assembling .s file...$(COLOR_RESET)\n"
	@ if not exist "$(dir $@)" mkdir "$(dir $@)"
# @ mkdir -p $(dir $@)
	$(CC) -c $(ASFLAGS) $(INC) -o $@ $<

$(OUT_SYS_DIR)/%.c.o: $(SYS_DIR)/%.c
	@ printf "$(COLOR_GREEN)Compiling .c file...$(COLOR_RESET)\n"
	@ if not exist "$(dir $@)" mkdir "$(dir $@)"
# @ mkdir -p $(dir $@)
	$(CC) -c $(CFLAGS) $(INC) -o $@ $<

$(OUT_SYS_DIR)/%.s.o: $(SYS_DIR)/%.s
	@ printf "$(COLOR_GREEN)Assembling .s file...$(COLOR_RESET)\n"
	@ if not exist "$(dir $@)" mkdir "$(dir $@)"
# @ mkdir -p $(dir $@)
	$(CC) -c $(ASFLAGS) $(INC) -o $@ $<

$(OUT_COMMON_DIR)/%.c.o: $(COMMON_DIR)/%.c
	@ printf "$(COLOR_GREEN)Compiling .c file...$(COLOR_RESET)\n"
	@ if not exist "$(dir $@)" mkdir "$(dir $@)"
# @ mkdir -p $(dir $@)
	$(CC) -c $(CFLAGS) $(UNITY_FLAGS) $(INC) -o $@ $<

$(OUT_COMMON_DIR)/%.s.o: $(COMMON_DIR)/%.s
	@ printf "$(COLOR_GREEN)Assembling .s file...$(COLOR_RESET)\n"
	@ if not exist "$(dir $@)" mkdir "$(dir $@)"
# @ mkdir -p $(dir $@)
	$(CC) -c $(ASFLAGS) $(UNITY_FLAGS) $(INC) -o $@ $<

$(OUT_TEST_DIR)/%.c.o: %.c
	@ printf "$(COLOR_GREEN)Compiling .c file...$(COLOR_RESET)\n"
	@ if not exist "$(dir $@)" mkdir "$(dir $@)"
# @ mkdir -p $(dir $@)
	$(CC) -c $(CFLAGS) $(UNITY_FLAGS) $(INC) -o $@ $<

$(OUT_TEST_DIR)/%.s.o: %.s
	@ printf "$(COLOR_GREEN)Assembling .s file...$(COLOR_RESET)\n"
	@ if not exist "$(dir $@)" mkdir "$(dir $@)"
# @ mkdir -p $(dir $@)
	$(CC) -c $(ASFLAGS) $(UNITY_FLAGS) $(INC) -o $@ $<

clean:
	rm -rf $(OUT_DIR)

test:
	@ echo $(SRC_DIR)
	@ echo $(OUT_SRC_DIR)
	@ echo $(SRC_OBJS)
	@ echo $(SYS_DIR)
	@ echo $(OUT_SYS_DIR)
	@ echo $(SYS_OBJS)
	@ echo $(COMMON_DIR)
	@ echo $(OUT_COMMON_DIR)
	@ echo $(COMMON_OBJS)

# Targets
.PHONY: all clean