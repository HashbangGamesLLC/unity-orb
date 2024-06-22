#!/bin/bash

# Install Git
brew install git

# Checkout Target Repository
git clone $TARGET_REPO_URL target-repo

# Define the build path
build_path="$unity_project_full_path/Builds/$PARAM_BUILD_TARGET"

# Copy Xcode Project to Target Repository
cp -R "$build_path"/* target-repo/

# Push Xcode Project to Repo
cd target-repo
git add .
git commit -m "Pushing updated Xcode project from recent build (CircleCi/Game-Ci)"
git push origin main

# Clean Up
cd ..
rm -rf target-repo
