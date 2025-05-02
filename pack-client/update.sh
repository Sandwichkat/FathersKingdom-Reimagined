#!/bin/bash

bootstrap_link="https://github.com/packwiz/packwiz-installer-bootstrap/releases/download/v0.0.3/packwiz-installer-bootstrap.jar"
bootstrap_output_dir="./packwiz-installer-bootstrap.jar"
packwiz_toml_link="https://sandwichkat.github.io/FathersKingdom-Reimagined/pack-client/pack.toml"

adoptium_link_macos="https://api.adoptium.net/v3/binary/latest/21/ga/mac/x64/jre/hotspot/normal/adoptium"
adoptium_dir="./updater/JRE"

# Detect if Java is on PATH
if command -v java &> /dev/null; then
    echo "Java not found on PATH."

    # Attempt to locate Adoptium JRE
    java_executable=$(find "$adoptium_dir" -type f -name "java" | head -n 1)
    if [ -n "$java_executable" ]; then
        echo "Local JRE found at $java_executable! Running..."
    else
        echo "Local JRE not found! Would you like to download a local JRE for the updater? (y/n)"
        read -r response
        if [ "$response" = "y" ]; then
            echo "Downloading Adoptium JRE..."

            # Create directory if it doesn't exist
            mkdir -p "$adoptium_dir"

            # Download and extract Adoptium JRE
            curl -L "$adoptium_link_macos" -o "$adoptium_dir/adoptium.tar.gz"
            echo "File downloaded."

            tar -xzf "$adoptium_dir/adoptium.tar.gz" -C "$adoptium_dir"
            echo "File extracted."

            echo "Cleaning up downloaded .tar.gz"
            rm "$adoptium_dir/adoptium.tar.gz"
        else
            exit 1 # Quit the script
        fi
    fi
fi

# Download bootstrap file if not present
if [ ! -f "$bootstrap_output_dir" ]; then
    echo "File not found, downloading..."
    curl -L "$bootstrap_link" -o "$bootstrap_output_dir"
else
    echo "Bootstrap already downloaded."
fi

# Run the bootstrap
if [ -f "$bootstrap_output_dir" ]; then
    echo "Running Bootstrap..."

    if ! command -v java &> /dev/null; then
        java -jar "$bootstrap_output_dir" "$packwiz_toml_link"
    else
        echo "Running bootstrap with local JRE..."
        java_executable=$(find "$adoptium_dir" -type f -name "java" | head -n 1)
        if [ -n "$java_executable" ]; then
            "$java_executable" -jar "$bootstrap_output_dir" "$packwiz_toml_link"
        else
            echo "Error: Unable to find the Java binary in the local JRE directory."
            exit 1
        fi
    fi
fi