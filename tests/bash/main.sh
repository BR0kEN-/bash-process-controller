#!/usr/bin/env bash

set +e

TESTS_DIR="$(pwd -P)"
ROOT_DIR="$(dirname "$TESTS_DIR")"
TESTS_DIR="$TESTS_DIR/$(dirname "$0")"

__run_test()
{
  local TEST_NAME="$1"
  local EXPECTED_EC="$2"
  local COMMAND=("$ROOT_DIR/main.sh" "/tmp/$TEST_NAME" "$TESTS_DIR/$TEST_NAME.sh")

  echo "Testing \"${COMMAND[@]}\"."

  ${COMMAND[@]}

  local ACTUAL_EC="$?"

  if [ "$EXPECTED_EC" != "$ACTUAL_EC" ]; then
    echo -e "\nThe expected exit code is \"$EXPECTED_EC\" when actual is \"$ACTUAL_EC\".\n"
    exit 1
  fi
}

__run_test __success 0
__run_test __fail-pre 1
__run_test __fail-main 2
__run_test __fail-post 3
__run_test __fail-clean 4
