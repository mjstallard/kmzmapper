#!/usr/bin/env bash

echo "Installing homebrew..."

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "Installing brew dependencies..."
brew install exiftool
brew install rbenv

echo "Installing ruby..."
rbenv install 2.3.1

echo "Installing ruby dependencies..."
gem install bundler
bundle

echo "Done!"
