#!/bin/bash

# log-archive - A CLI tool to compress and archive log directories
# Author: Gemini
# Date: 2026-04-23

# --- Configuration ---
# Directory where the compressed archives will be stored
ARCHIVE_DEST="./archived_logs"
# File where the archive history is recorded
RECORD_FILE="./archive_history.log"

# --- Argument Validation ---
if [ -z "$1" ]; then
    echo "Error: Missing target directory."
    echo "Usage: ./log-archive <log-directory>"
    exit 1
fi

TARGET_DIR="$1"

# Check if the target directory actually exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory '$TARGET_DIR' does not exist."
    exit 1
fi

# --- Setup ---
# Ensure the destination directory exists
mkdir -p "$ARCHIVE_DEST"

# Generate the timestamp (Format: YYYYMMDD_HHMMSS)
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
ARCHIVE_NAME="logs_archive_${TIMESTAMP}.tar.gz"
ARCHIVE_PATH="${ARCHIVE_DEST}/${ARCHIVE_NAME}"

# --- Archiving ---
echo "Compressing logs from '$TARGET_DIR'..."

# -c: create, -z: gzip, -f: file.
# -C changes the directory before archiving so the tarball doesn't include the full absolute path structure
tar -czf "$ARCHIVE_PATH" -C "$TARGET_DIR" .

if [ $? -eq 0 ]; then
    echo "Success! Archive created at: $ARCHIVE_PATH"
    
    # Log the date and time of the archive
    LOG_TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
    echo "[$LOG_TIMESTAMP] Archived '$TARGET_DIR' -> '$ARCHIVE_PATH'" >> "$RECORD_FILE"
else
    echo "Error: Failed to create the archive."
    exit 1
fi
