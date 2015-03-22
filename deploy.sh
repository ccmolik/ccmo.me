#!/usr/bin/env bash

set -e # halt script on error
# Get rbenv going
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
rbenv shell 1.9.3-p547
bundle install
rbenv rehash
# Do all of the grunt bs
npm install
grunt
bundle exec jekyll build
rsync -av --progress --exclude="*.sh" --exclude="Gemfile*" --exclude=".DS_Store" --exclude="node_modules" ./_site/ $1/
