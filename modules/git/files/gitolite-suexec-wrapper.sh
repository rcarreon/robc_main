#!/bin/bash

export GIT_PROJECT_ROOT="/app/shared/git"
export GITOLITE_HTTP_HOME="/app/shared/gitolite"

exec /usr/share/gitolite3/gitolite-shell
