#!/bin/sh

##############################################################################
# Cursor Rules Project Initializer
#
# This script sets up a new project with the Cursor rules and documentation.
# It can be run directly or via a pipe (e.g. curl ... | sh).
##############################################################################

# Colors and formatting
BOLD="$(tput bold 2>/dev/null || echo)"
RED="$(tput setaf 1 2>/dev/null || echo)"
GRN="$(tput setaf 2 2>/dev/null || echo)"
YEL="$(tput setaf 3 2>/dev/null || echo)"
NRM="$(tput sgr0 2>/dev/null || echo)"

info() { printf '%s\n' "${YEL}==> $*${NRM}"; }
ok()   { printf '%s\n' "${GRN}✔ $*${NRM}"; }
err()  { printf '%s\n' "${RED}✖ $*${NRM}"; }

# Detect if run from a pipe (not a tty on stdin)
if [ -t 0 ]; then
  INTERACTIVE=true
else
  INTERACTIVE=false
fi

# Set up target directories
RULES_DIR=".cursor/rules"
DOCS_PROJECT="docs/project"
DOCS_PRPS="docs/prps"

# Check for existing directories
if [ -d "$RULES_DIR" ]; then
  err ".cursor/rules already exists. Aborting to avoid overwrite."
  exit 1
fi
if [ -d "$DOCS_PROJECT" ]; then
  err "docs/project already exists. Aborting to avoid overwrite."
  exit 1
fi
if [ -d "$DOCS_PRPS" ]; then
  err "docs/prps already exists. Aborting to avoid overwrite."
  exit 1
fi

# Check for existing RULES_HOWTO.md
if [ -f "RULES_HOWTO.md" ]; then
  err "RULES_HOWTO.md already exists. Aborting to avoid overwrite."
  exit 1
fi

# Create directories
mkdir -p "$RULES_DIR" "$DOCS_PROJECT" "$DOCS_PRPS"

GITHUB_REPO="gertalot/cursor-rules"
RELEASE_URL="https://github.com/$GITHUB_REPO/releases/latest/download/cursor-rules.tar.gz"
README_URL="https://raw.githubusercontent.com/$GITHUB_REPO/main/README.md"

if [ "$INTERACTIVE" = true ]; then
  # Run directly: copy from local repo (where this script is located)
  SCRIPT_DIR="$(cd "$(dirname -- "$0")" && pwd)"
  # Copy rules
  if [ -d "$SCRIPT_DIR/rules" ]; then
    for f in "$SCRIPT_DIR"/rules/*.mdc; do
      cp "$f" "$RULES_DIR/" || { err "Failed to copy $f"; exit 1; }
    done
    ok "Copied rules/*.mdc to $RULES_DIR"
  else
    err "rules directory not found in $SCRIPT_DIR."
    exit 1
  fi
  # Copy README.md
  if [ -f "$SCRIPT_DIR/README.md" ]; then
    cp "$SCRIPT_DIR/README.md" RULES_HOWTO.md
    ok "Copied README.md from repo to RULES_HOWTO.md"
  else
    err "README.md not found in $SCRIPT_DIR."
    exit 1
  fi
else
  # Run from pipe: download from GitHub release (latest)
  TMPDIR=".cursor_rules_tmp_$$"
  mkdir -p "$TMPDIR"
  info "Downloading rules from $RELEASE_URL ..."
  if command -v curl >/dev/null 2>&1; then
    curl -sSL "$RELEASE_URL" | tar xz -C "$TMPDIR" || { err "Download or extraction failed."; rm -rf "$TMPDIR"; exit 1; }
    curl -sSL "$README_URL" -o RULES_HOWTO.md || { err "Failed to download README.md."; rm -rf "$TMPDIR"; exit 1; }
  elif command -v wget >/dev/null 2>&1; then
    wget -qO- "$RELEASE_URL" | tar xz -C "$TMPDIR" || { err "Download or extraction failed."; rm -rf "$TMPDIR"; exit 1; }
    wget -q "$README_URL" -O RULES_HOWTO.md || { err "Failed to download README.md."; rm -rf "$TMPDIR"; exit 1; }
  else
    err "Neither curl nor wget found. Cannot download rules or README.md."
    rm -rf "$TMPDIR"
    exit 1
  fi
  # Copy rules to .cursor/rules
  for f in "$TMPDIR"/rules/*.mdc; do
    cp "$f" "$RULES_DIR/" || { err "Failed to copy $f"; rm -rf "$TMPDIR"; exit 1; }
  done
  rm -rf "$TMPDIR"
  ok "Downloaded and installed rules to $RULES_DIR"
  ok "Downloaded README.md to RULES_HOWTO.md"
fi

ok "Project initialized!"
info "You can now start developing your project. Check the RULES_HOWTO.md file for more information." 