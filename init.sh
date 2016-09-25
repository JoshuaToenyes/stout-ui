#! /bin/bash

LIB_DIR=lib

# Install all npm packages and dependencies.
npm install

# Install and update Bourbon and SASS.
mkdir -p $LIB_DIR
cd $LIB_DIR
bourbon install

exit 0
