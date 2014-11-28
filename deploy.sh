#!/usr/bin/env bash

set -e # halt script on error
# Get rbenv going
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
rbenv shell 1.9.3-p547
bundle install
rbenv rehash

bundle exec jekyll build
rsync -av --delete --progress --exclude="*.sh" --exclude="Gemfile*" ./_site/ $1/
