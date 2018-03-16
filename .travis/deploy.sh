#!/usr/bin/env bash

set -ev # show commands run and terminate on non-zero exit code

if [ $TRAVIS_BRANCH = master ]; then
  # create commit of _book folder
  cp CNAME _build
  cd _book
  git init
  git add .
  git -c user.name='Deployment Bot' -c user.email='deploy@travis-ci.org' commit -m "Auto-deploy from Travis CI"

  # push to gh-pages branch
  openssl aes-256-cbc -K $encrypted_81bb60eb1b21_key -iv $encrypted_81bb60eb1b21_iv -in id_deploy.enc -out .travis/id_deploy -d
  ssh-add .travis/id_deploy
  git push -f -q "ssh://git@github.com/$TRAVIS_REPO_SLUG.git" gh-pages
fi
