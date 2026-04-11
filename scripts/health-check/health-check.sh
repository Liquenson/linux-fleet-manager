#!/usr/bin/env bash

echo "Running health check..."

OS=$(uname)

if [[ "$OS" == "Linux" ]]; then
    echo "[INFO] Linux system detected"

    uptime
    df -h
    free -m

elif [[ "$OS" == "Darwin" ]]; then
    echo "[INFO] macOS system detected"

    uptime
    df -h

elif [[ "$OS" == "MINGW"* || "$OS" == "MSYS"* ]]; then
    echo "[WARN] Running on Windows (Git Bash)"

    echo "Disk usage:"
    df -h

    echo "Basic system info:"
    systeminfo | grep "Total Physical Memory" 2>/dev/null || echo "Memory info not available"

else
    echo "[ERROR] Unsupported OS: $OS"
fi
