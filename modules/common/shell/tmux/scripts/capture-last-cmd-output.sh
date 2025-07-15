#!/usr/bin/env bash

# Define the shell prompt pattern to identify command boundaries
PROMPT_PATTERN="➜ "

tmux_output=$(tmux capture-pane -p -S '-' -J)

# Extract the content between the last two prompts
extracted_output=$(echo "$tmux_output" | tac |
  sed -e "0,/$PROMPT_PATTERN/d" |
  sed "/$PROMPT_PATTERN/,\$d" |
  tac)

# Copy the extracted output to the system clipboard
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "$extracted_output" | pbcopy
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  if command -v xclip &>/dev/null; then
    echo "$extracted_output" | xclip -selection clipboard
  elif command -v xsel &>/dev/null; then
    echo "$extracted_output" | xsel --clipboard --input
  else
    echo "Error: Neither xclip nor xsel is installed. Please install one to enable clipboard copy." >&2
    exit 1
  fi
else
  echo "Unsupported OS: $OSTYPE" >&2
  exit 1
fi
