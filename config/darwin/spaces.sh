#!/bin/bash
echo "attempting to create workspaces"

sudo yabai --load-sa || { echo "Failed to load service agent"; exit 1; }

num_spaces=$(yabai -m query --spaces | jq length)
echo "Current number of spaces: $num_spaces"

for i in $(seq $num_spaces -1 2); do
    echo "Destroying space $i"
    yabai -m space $i --destroy || echo "Failed to destroy space $i"
done

desired_spaces=5
spaces_to_create=$((desired_spaces - 1))  # Space 1 always exists

for i in $(seq 1 $spaces_to_create); do
    echo "Creating space $i"
    yabai -m space --create || echo "Failed to create space"
done

skhd -r || { echo "Failed to load keybindings"; exit 1; }
echo "loaded keybindings"
echo "Created workspaces"
