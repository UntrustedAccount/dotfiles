#!/usr/bin/env bash

if git diff --quiet '*.nix'; then
	exit 0
fi

alejandra . &>/dev/null || ( alejandra . ; echo "formatting failed!" && exit 1)

git diff -U0 '*.nix'

sudo nixos-rebuild switch -I nixos-config="./configuration.nix" &>nixos-switch.log || (cat nixos-switch.log | grep --color error && exit 1)

current=$(nixos-rebuild list-generations | grep current)
git commit -am "$current"
