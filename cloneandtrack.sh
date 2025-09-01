#!/bin/bash
set -e

# Check if a repository URL was provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <repo-url>"
  exit 1
fi

REPO_URL="$1"
# Derive repository name from the URL (assumes URL ends with .git)
REPO_NAME=$(basename "$REPO_URL" .git)

echo "Cloning repository $REPO_URL..."
git clone "$REPO_URL"
cd "$REPO_NAME" || { echo "Failed to enter repository directory."; exit 1; }

echo "Fetching all remote branches..."
git fetch --all

# Create local tracking branches for all remote branches except symbolic refs (e.g., HEAD)
echo "Setting up tracking branches for remote branches..."
for remote in $(git branch -r | grep -v '\->'); do
    # Remove the remote name prefix (assumes remote is 'origin')
    branch=${remote#origin/}
    
    # Check if the branch already exists locally
    if ! git show-ref --verify --quiet "refs/heads/$branch"; then
        echo "Creating local branch '$branch' tracking '$remote'"
        git branch --track "$branch" "$remote"
    else
        echo "Local branch '$branch' already exists; skipping..."
    fi
done

echo "All remote branches are now tracked locally!"
