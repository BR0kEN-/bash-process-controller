#!/usr/bin/env bash

set -e

LOCK_FILE="$1"
TASKS_FILE="$2"
MAIN_HANDLER="PROCESS_main"

if [ -f "$TASKS_FILE" ]; then
  # Attach the tasks.
  source "$TASKS_FILE"
fi

if [ "$(type -t "$MAIN_HANDLER")" != "function" ]; then
  echo "You must have at least \"$MAIN_HANDLER\" Bash function defined!"
  exit 99
fi

# Run the process.
"$(dirname "$0")/process.sh" "$LOCK_FILE"
# Read final exit code of the process.
EXIT_CODE="$(cat "$LOCK_FILE")"
# Release the lock.
rm "$LOCK_FILE"
# Print the exit code.
echo "Exit with \"$EXIT_CODE\"."
# End the process.
exit "$EXIT_CODE"
