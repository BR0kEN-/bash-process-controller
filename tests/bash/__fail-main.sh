#!/usr/bin/env bash

set +e

PROCESS_pre() {
  echo "pre"
}

PROCESS_main() {
  echo "main (pre exited with $PROCESS_EXIT_CODE)"
  return 2
}

PROCESS_post() {
  echo "post (main exited with $PROCESS_EXIT_CODE)"

  # Ensure the code returned from "PROCESS_main" preserved.
  if [ "$PROCESS_EXIT_CODE" != 2 ]; then
    return 3
  fi
}

PROCESS_clean() {
  echo "clean (post exited with $PROCESS_EXIT_CODE)"
}

PROCESS_finish() {
  echo "finish (clean exited with $PROCESS_EXIT_CODE)"
}

export -f PROCESS_pre PROCESS_main PROCESS_post PROCESS_clean PROCESS_finish
