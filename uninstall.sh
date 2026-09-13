#!/bin/bash

sudo docker rmi local-storcli:latest
sudo docker builder prune -f

BASHRC="$HOME/.bashrc"

# Remove storcli64 alias from .bashrc
sed -i "/^[[:space:]]*alias storcli64=/d" "$BASHRC"

# Remove alias from current shell
unalias storcli64 2>/dev/null || true

# Reload .bashrc
source "$BASHRC"

echo "storcli64 alias removed."
