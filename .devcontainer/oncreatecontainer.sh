#!/bin/sh

set -e

# assume it is running in repository's root directory
./.devcontainer/scripts/setup-deps.sh
./.devcontainer/scripts/enable-act-artifact.sh
./.devcontainer/scripts/setup-act-cache-server.sh