#!/bin/bash

# Define the directory to search for SF2 files
dir=~/Sound\ Font

# Use find to search for SF2 files in the directory and its subdirectories
sf2_files=$(find "$dir" -iname '*.SF2' -type f)

# If no SF2 files were found, exit the script
if [ -z "$sf2_files" ]; then
    echo "Oops! We couldn't find any instruments in $dir. Please make sure you have some SF2 files in that directory."
    exit 1
fi

# Count the number of SF2 files found
num_sf2_files=$(echo "$sf2_files" | wc -l)

# Print a header
echo "======================================"
echo "  Choose Your Instrument!"
echo "======================================"
echo "Our collection of sounds is sure to inspire you! Please choose an instrument from the list below:"
echo

# Loop through the list of SF2 files and present them to the user with a number
for i in $(seq 1 $num_sf2_files); do
    sf2_file=$(echo "$sf2_files" | sed "${i}q;d")
    echo "[$i] ${sf2_file##*/}"
done

# Ask the user to select a file
echo
read -p "Enter the number of the instrument you'd like to play: " choice
echo

# Ensure the user's choice is valid
if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt $num_sf2_files ]; then
    echo "Oops! That's not a valid choice. Please select a number from 1 to $num_sf2_files."
    exit 1
fi

# Get the full path to the chosen file
chosen_file=$(echo "$sf2_files" | sed "${choice}q;d")

# Run the sfizz_jack command with the chosen file's path
echo "Great choice! Let's get creative with the ${chosen_file##*/} sound..."
sfizz_jack "$chosen_file"
