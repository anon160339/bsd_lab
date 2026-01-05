#!/usr/bin/env bash
set -euo pipefail

#######################################
# CONFIG
#######################################

REMOTE=$(cat remote)
echo "$REMOTE"

SRC_REPO=".."                 # source repo path or URL
DEST_REPO="bsd_lab_public"     # rewritten repo directory

NEW_NAME="Anon"
NEW_EMAIL="@"

#######################################
# CHECK DEPENDENCIES
#######################################

if ! python3 -m git_filter_repo --version >/dev/null 2>&1; then
    echo "[ERROR] git-filter-repo not found."
    echo "Install with: pip install git-filter-repo"
    exit 1
fi

#######################################
# CLEAN OLD REPO
#######################################

if [ -d "$DEST_REPO" ]; then
    echo "[INFO] Removing old fake repository..."
    rm -rf "$DEST_REPO"
fi

#######################################
# CLONE SOURCE
#######################################

echo "[INFO] Cloning source repository..."
git clone "$SRC_REPO" "$DEST_REPO"

cd "$DEST_REPO"

#######################################
# HARDEN GIT CONFIG (NO SIGNING / NO ID)
#######################################

git config --local user.name "$NEW_NAME"
git config --local user.email "$NEW_EMAIL"
git config --local commit.gpgsign false
git config --local tag.gpgsign false
git config --local gpg.program false
#git config --local credential.helper ""
#git config --local --unset credential.helper


#######################################
# REWRITE HISTORY (ANON + STRIP SIGS)
#######################################

echo "[INFO] Anonymizing commits and stripping signatures..."

python3 -m git_filter_repo --force \
  --name-callback "return b'$NEW_NAME'" \
  --email-callback "return b'$NEW_EMAIL'" \
  --commit-callback '
commit.author_name  = b"'"$NEW_NAME"'"
commit.author_email = b"'"$NEW_EMAIL"'"
commit.committer_name  = b"'"$NEW_NAME"'"
commit.committer_email = b"'"$NEW_EMAIL"'"
commit.gpgsig = None
'

#######################################
# ADD REMOTE (OPTIONAL)
#######################################

git remote add origin "$REMOTE"
echo 11

#######################################
# CLONE CLEAN VERSION FOR USE
#######################################

cd "$(dirname "$SRC_REPO")" 2>/dev/null || true

if [ -d "${DEST_REPO}-cloned" ]; then
    rm -rf "${DEST_REPO}-cloned"
fi

git clone "$DEST_REPO" "${DEST_REPO}-cloned"

echo "[SUCCESS] Fake repository created at '${DEST_REPO}-cloned'"
