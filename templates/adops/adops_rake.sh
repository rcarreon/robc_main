#!/usr/bin/env bash

gemfile=/app/shared/docroots/adops.gorillanation.com/current/Gemfile

rakefile=/app/shared/docroots/adops.gorillanation.com/current/Rakefile

BUNDLE_GEMFILE=$gemfile bundle exec rake -f $rakefile $1
