#!/usr/bin/env bash
set -euo pipefail

# Usage check
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 {create|delete} <users.csv>" >&2
    echo "CSV Format: username,password" >&2
    exit 1
fi

ACTION="$1"
CSV_FILE="$2"

if [ ! -f "$CSV_FILE" ]; then
    echo "Error: File $CSV_FILE not found." >&2
    exit 1
fi

process_create() {
    local username="$1"
    local password="$2"
    
    if id "$username" &>/dev/null; then
        echo "User '$username' already exists. Skipping."
    else
        # Create user with a home directory and default bash shell
        sudo useradd -m -s /bin/bash "$username"
        # Set the password securely via chpasswd
        echo "$username:$password" | sudo chpasswd
        echo "Successfully created user: $username"
    fi
}

process_delete() {
    local username="$1"
    
    if id "$username" &>/dev/null; then
        # Delete user and remove their entire home directory structure (-r)
        sudo userdel -r "$username"
        echo "Successfully deleted user: $username"
    else
        echo "User '$username' does not exist. Skipping."
    fi
}

# Read CSV file line-by-line, splitting on commas
while IFS=',' read -r username password || [ -n "$username" ]; do
    # Strip carriage returns if file was edited in Windows (CRLF)
    username=$(echo "$username" | tr -d '\r ' )
    password=$(echo "$password" | tr -d '\r ' )
    
    # Skip empty lines or header rows
    if [ -z "$username" ] || [ "$username" = "username" ]; then
        continue
    fi

    case "$ACTION" in
        create)
            if [ -z "$password" ]; then
                echo "Warning: No password specified for $username. Skipping." >&2
                continue
            fi
            process_create "$username" "$password"
            ;;
        delete)
            process_delete "$username"
            ;;
        *)
            echo "Invalid action: $ACTION. Use 'create' or 'delete'." >&2
            exit 1
            ;;
    esac
done < "$CSV_FILE"