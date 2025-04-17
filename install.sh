#!/bin/bash

# Function to check if s() already exists in a file
check_function_exists() {
    local config_file="$1"
    if [ -f "$config_file" ]; then
        if grep -q "^s()" "$config_file"; then
            return 0  # Function exists
        fi
    fi
    return 1  # Function doesn't exist
}

# The function definition
read -r -d '' FUNCTION_CODE << 'EOF'
s() {
  local search="$1"
  [[ -n "$2" ]] && search+=" $2"
  [[ -n "$3" ]] && search+=" $3"
  # Use an associative array to filter unique commands
  declare -A seen
  local results=()
  # Read history and filter by search, then dedupe based on actual command
  while IFS= read -r line; do
    # Strip history number and possible asterisk
    local cmd=$(echo "$line" | sed -E 's/^[[:space:]]*[0-9]+\*?[[:space:]]+//')
    if [[ -z "${seen["$cmd"]}" ]]; then
      seen["$cmd"]=1
      results+=("$cmd")
    fi
  done < <(history | grep -i "$search")
  # If no results found
  if [ ${#results[@]} -eq 0 ]; then
    echo "No matching commands found."
    return 1
  fi

  # Display numbered list of unique commands
  local i=1
  for cmd in "${results[@]}"; do
    echo "  $i) $cmd"
    ((i++))
  done

  # Prompt for selection
  echo -n "Enter number to execute (or press Enter to cancel): "
  read choice

  # Execute chosen command if valid number is entered
  if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le ${#results[@]} ]; then
    local full_cmd="${results[$choice]}"
    echo "Executing: $full_cmd"
    eval "$full_cmd"
  fi
}
EOF

# Detect shell and config file
CURRENT_SHELL=$(basename "$SHELL")

if [ "$CURRENT_SHELL" = "zsh" ]; then
    SHELL_TYPE="zsh"
    CONFIG_FILE="$HOME/.zshrc"
    echo "✓ Detected shell: Zsh"
elif [ "$CURRENT_SHELL" = "bash" ]; then
    SHELL_TYPE="bash"
    CONFIG_FILE="$HOME/.bashrc"
    echo "✓ Detected shell: Bash"
    # For macOS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        CONFIG_FILE="$HOME/.bash_profile"
        echo "✓ Detected OS: macOS, using .bash_profile instead of .bashrc"
    else
        echo "✓ Detected OS: Linux/Other, using .bashrc"
    fi
else
    echo "❌ Error: Unsupported shell: $CURRENT_SHELL. Only bash and zsh are supported."
    echo "Current shell path: $SHELL"
    exit 1
fi

echo "✓ Configuration will be added to: $CONFIG_FILE"
if [ -f "$CONFIG_FILE" ]; then
    echo "✓ Configuration file exists"
else
    echo "! Configuration file does not exist, it will be created"
fi

# Check if function already exists
if check_function_exists "$CONFIG_FILE"; then
    echo "Error: s() function already exists in $CONFIG_FILE"
    echo "Please remove or rename the existing function before installing."
    exit 1
fi

# Add function to config file
echo "" >> "$CONFIG_FILE"
echo "# Command history search function" >> "$CONFIG_FILE"
echo "$FUNCTION_CODE" >> "$CONFIG_FILE"

echo "Installation successful!"
echo "The s() function has been added to $CONFIG_FILE"
echo "To start using it, either:"
echo "1. Restart your terminal"
echo "2. Run: source $CONFIG_FILE" 