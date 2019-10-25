#!/bin/bash

set -x
set -u
set -e

git status
git add -A
git commit -m "fast upload"
git push
