# STM32 Project Template for VS Code

This template provides a starting point for developing STM32 project using VS Code. It includes configurations for building, debugging and minor IntelliSense support.


## Other MCU

To use some other STM32 MCU the following parts may need to be added/modified:
- MCU specific `.svd` file (and a corresponding property in `launch.json`)
- gdb-server configuration file(s)
- CMSIS headers (`src/sys/CMSIS/`), assembly startup file (`src/sys/startup_stm32xx.s`), linker script (`src/sys/STM32xx_FLASH.ld`)
- `src/Makefile` and `src/sys/sys.mk`

## Other gdb-server and debugger

To use some other gdb-server and/or debugger the following parts may need to be added/modified:
- path to gdb-server binary in `settings.json`
- configuration file(s) required by a specific gdb-server
- properties corresponding to the above in `launch.json`

See [Cortex-Debug](https://github.com/Marus/cortex-debug) for supported gdb-servers.

## IntelliSense issue

There is a problem with a detection of the **define symbols** (`"-Dxxx"`) from Makefile files. Although it doesn't stop the compilation process to be performed correctly, it may cause annoying error squiggles. 

Maybe it can be solved somehow with C/C++ and Makefile Tools extensions' configurations. But easier way is to use [Bear](https://github.com/rizsotto/Bear) tool. Its usage is as simple as:
```bash
bear -- make
```
It generates `compile_commands.json` file with all the compilation commands that can be passed to project's `c_cpp_properties.json`.

The drawback is that **Bear** cannot be used with *make dry run* (`make -n`), as it only works when the actual compilation takes place. Therefore, the whole build must be performed every time you want to update the compilation info.

## Acknowledgments
[[PORADNIK Live 📡] Projekt STM32 od ZERA #1 (arm-none-eabi VSCode openocd)](https://www.youtube.com/live/dU09fTlVT-8?si=vMoLfxb_9AtuMBb-)