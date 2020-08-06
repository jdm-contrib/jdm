#!/usr/bin/env bash
set -e # halt script on error

CWD=$(pwd)

cd '../_data/'
# sorts everything by name
jq '. | sort_by(.name|ascii_downcase)' sites.json > a.json

cd $CWD
