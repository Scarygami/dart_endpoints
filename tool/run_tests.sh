#!/bin/bash

REPO_ROOT=$( cd $(dirname $(dirname "${BASH_SOURCE[0]}" )) && pwd )

# Source utility functions
source "$REPO_ROOT/tool/utils.sh"

export RETURN_VALUE=0

start_phase "Analyzing"
analyze_files $REPO_ROOT/lib/*.dart
RETURN_VALUE=$(expr $RETURN_VALUE + $?)

analyze_files $REPO_ROOT/lib/src/*.dart
RETURN_VALUE=$(expr $RETURN_VALUE + $?)

analyze_files $REPO_ROOT/test/*.dart
RETURN_VALUE=$(expr $RETURN_VALUE + $?)

analyze_files $REPO_ROOT/test/src/*.dart
RETURN_VALUE=$(expr $RETURN_VALUE + $?)

start_phase "Testing"
for testfile in $(find $REPO_ROOT/test -name "*test.dart"); do
  pushd "$REPO_ROOT/test"
    test_file "$testfile"
    RETURN_VALUE=$(expr $RETURN_VALUE + $?)
  popd
done

test $RETURN_VALUE -ne 0 && exit 1
exit 0
