#!/bin/bash

COMPILE_COMMANDS_FILE="compile_commands.json"

# Check if the file exists
if [ ! -f "$COMPILE_COMMANDS_FILE" ]; then
    # If the file does not exist, run the "Update Compilation Info" task first
    echo "Compilation info not found."
    echo "Running 'Update Compilation Info'..."
    # Run the command used in "Update Compilation Info" task to generate the compile_commands.json file
    bear -- make -B
    echo ""
fi

# Run the normal build after compilation info is updated or already present
echo "Running Build STM..."
make