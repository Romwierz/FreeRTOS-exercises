TARGET = my_math

# Source files
SRC_FILES = \
../../src/my_math.c

SYS_FILES = \
../../src/sys/syscalls.c \
../../src/sys/startup_stm32l476rgtx.s

COMMON_FILES = \
../common/unity_runner.c \
../common/unity_fixture.c \
../common/unity.c

TEST_FILES = \
test_runner.c \
my_math_test.c

# Include paths
INC = \
-I../common \
-I../../src \
-I../../src/sys/CMSIS

include ../common/common.mk