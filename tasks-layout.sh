#!/usr/bin/env bash

# Allows continuing the process regardless of an exit code at one of the stages.
set +e

# The "PROCESS_EXIT_CODE" variable is available inside every of the "PROCESS_"
# functions and contains an exit code of the previous handler.
#
# Calls sequence:
# - PROCESS_pre
# - PROCESS_main
# - PROCESS_post
# - PROCESS_clean
# - PROCESS_finish
#
# An exit code of every process handler, except "PROCESS_finish", is able to
# break the entire process. The "finish" can fail but it won't be considered
# as a failure of an execution.
#
# It is not possible to "fix" the entire process when the previous handler
# has failed. For instance "PROCESS_post" exited with "23" status code but
# the "PROCESS_clean" has been successfully completed. The final execution
# code will remain "23" until the end of the process unless any other handler
# return another non-zero code.

PROCESS_pre() {
  echo "pre"
  return 0
}

PROCESS_main() {
  echo "main"
  return 0
}

PROCESS_post() {
  echo "post"
  return 0
}

PROCESS_clean() {
  echo "clean"
  return 0
}

PROCESS_finish() {
  echo "finish"
}

export -f PROCESS_pre PROCESS_main PROCESS_post PROCESS_clean PROCESS_finish
