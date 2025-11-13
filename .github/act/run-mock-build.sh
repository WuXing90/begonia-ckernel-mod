#!/bin/sh

# assuming running in root repo
act workflow_dispatch -e ./.github/act/mock-build.json -s GITHUB_TOKEN=$GITHUB_TOKEN