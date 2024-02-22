#!/usr/bin/env bash
set -e # halt script on error

# Validate all files adhere to .editorconfig
# Exclude files which should not be checked against .editorconfig
# (eg. images, LICENSE, system-generated files, and library files)
mapfile -t editorconfigargs < <(
    find . \
        -type 'f' \
        ! -name '*.png' \
        ! -name '*.ico' \
        ! -name 'CNAME' \
        ! -name 'LICENSE' \
        ! -name 'Gemfile.lock' \
        ! -path './assets/*/libs/*' \
        ! -path './.bundle/*' \
        ! -path './.git/*' \
        ! -path './_site/*' \
        ! -path './vendor/*' \
)
npx @htmlacademy/editorconfig-cli "${editorconfigargs[@]}"
