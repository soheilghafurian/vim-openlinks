#!/bin/bash
# Run vader.vim tests for the openlinks plugin
# Usage: ./test/run_tests.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
VADER_DIR="$PLUGIN_DIR/test/vader.vim"

# Clone vader.vim if not present
if [ ! -d "$VADER_DIR" ]; then
  echo "Cloning vader.vim..."
  git clone --depth 1 https://github.com/junegunn/vader.vim.git "$VADER_DIR"
fi

echo "Running tests..."
vim -Nu <(cat <<VIMRC
set nocompatible
filetype off
set rtp+=$VADER_DIR
set rtp+=$PLUGIN_DIR
filetype plugin indent on
VIMRC
) -c "Vader! $PLUGIN_DIR/test/openlinks.vader" 2>&1

exit_code=$?
echo ""
if [ $exit_code -eq 0 ]; then
  echo "All tests passed."
else
  echo "Some tests failed (exit code: $exit_code)."
fi
exit $exit_code
