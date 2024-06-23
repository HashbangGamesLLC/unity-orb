#!/bin/bash

# Install Git
brew install git

# Ensure SSH is configured correctly
mkdir -p ~/.ssh
ssh-keyscan github.com >> ~/.ssh/known_hosts

# Ensure the target-repo directory does not exist
if [ -d "target-repo" ]; then
  echo "Removing existing target-repo directory"
  rm -rf target-repo
fi

# Checkout Target Repository using the specific SSH key
GIT_SSH_COMMAND="ssh -i ~/.ssh/id_rsa" git clone "$TARGET_REPO_URL" target-repo

# Debug: Print the repository URL
echo "Cloning $TARGET_REPO_URL"

# Checkout Target Repository
# git clone $TARGET_REPO_URL target-repo

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
