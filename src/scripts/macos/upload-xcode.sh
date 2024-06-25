#!/bin/bash

readonly base_dir="${CIRCLE_WORKING_DIRECTORY/\~/$HOME}"
readonly unity_project_full_path="$base_dir/$PROJECT_PATH"

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

echo "Setting Distiller User in Git"
git config --global user.email "distiller@circleci.com"
git config --global user.name "distiller"

# Verify global configuration
echo "Global user.email: $(git config --global user.email)"
echo "Global user.name: $(git config --global user.name)"

# Debug: Print the repository URL
echo "Cloning $TARGET_REPO_URL"

# Checkout Target Repository using the specific SSH key
GIT_SSH_COMMAND="ssh -i ~/.ssh/id_rsa" git clone "$TARGET_REPO_URL" target-repo

# Define the build path
build_path="$unity_project_full_path/Builds/$BUILD_TARGET"

echo "Build Path - $build_path"

# Copy Xcode Project to Target Repository
cp -R "$build_path"* target-repo/

# Push Xcode Project to Repo
echo "Push Xcode Project to Repo"
cd target-repo
git add .
git commit -m "Pushing updated Xcode project from recent build (CircleCi/Game-Ci)"
git push origin main

# Clean Up
echo "Cleaning Up target repo"
cd ..
rm -rf target-repo
