#!/usr/bin/env bash

set -e

export PROCESS_LOCK_ID="$1"
export PROCESS_EXIT_CODE=0

if [ -z "$PROCESS_LOCK_ID" ]; then
  echo "You must pass the unique lock ID for this job!"
  exit 100
fi

# ------------------------------------------------------------------------------

ci_run() {
  local FUNC="PROCESS_$1"

  if [ "$(type -t "$FUNC")" == "function" ]; then
    ${FUNC}
  else
    echo "==> WARNING: Unable to run the \"$FUNC\" since it doesn't exist!"
  fi
}

ci_hook() {
  # shellcheck disable=SC2064
  # https://github.com/koalaman/shellcheck/wiki/SC2064
  trap "$2" EXIT
  ci_run "$1"
}

ci_lock() {
  local NEW_EXIT_CODE="$1"

  # An exit code of a previous stage is greater than zero (an
  # error occurred), but the next stage has passed successfully.
  if [[ "$PROCESS_EXIT_CODE" -gt 0 && "$NEW_EXIT_CODE" -eq 0 ]]; then
    # E.g.: "post_deploy" failed but "server_cleaner" succeeded.
    echo "==> WARNING: An attempt to downgrade the \"$PROCESS_EXIT_CODE\" exit code to zero has been refused."
  else
    PROCESS_EXIT_CODE="$NEW_EXIT_CODE"
    echo "$PROCESS_EXIT_CODE" > "$PROCESS_LOCK_ID"
  fi
}

post() {
  ci_lock $?
  bash -c "ci_hook ${FUNCNAME[0]} clean"
}

clean() {
  ci_lock $?
  bash -c "ci_hook ${FUNCNAME[0]} finish"
}

finish() {
  ci_lock $?
  ci_run finish
}

# ------------------------------------------------------------------------------

export -f ci_run ci_hook ci_lock post clean finish

ci_hook pre post
ci_run main
