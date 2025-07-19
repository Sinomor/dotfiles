#!/bin/bash

# Niri App Switcher - Combined script for app focusing and cycling
# Usage: 
#   niri-app-switcher.sh focus <number>     # Focus app by number (1-9)
#   niri-app-switcher.sh next               # Cycle to next app
#   niri-app-switcher.sh prev               # Cycle to previous app

# Common function to get workspace data
get_workspace_data() {
    local workspaces=$(niri msg --json workspaces)
    local windows=$(niri msg --json windows)
    
    # Get current active workspace ID
    local current_workspace_id=$(echo "$workspaces" | jq -r '.[] | select(.is_active == true) | .id')
    
    if [ -z "$current_workspace_id" ]; then
        exit 1
    fi
    
    # Get windows on current workspace, sorted by window ID
    local workspace_windows=$(echo "$windows" | jq -r --arg ws_id "$current_workspace_id" '
        [.[] | select(.workspace_id == ($ws_id | tonumber))] | 
        sort_by(.id)'
    )
    
    echo "$workspace_windows"
}

# Function to focus app by number
focus_app_by_number() {
    local app_number=$1
    
    # Validate input is a number between 1-9
    if ! [[ "$app_number" =~ ^[1-9]$ ]]; then
        exit 1
    fi
    
    # Get workspace windows
    local workspace_data=$(get_workspace_data)
    
    if [ -z "$workspace_data" ] || [ "$workspace_data" = "[]" ]; then
        exit 1
    fi
    
    # Get window IDs array
    local window_ids=($(echo "$workspace_data" | jq -r '.[].id'))
    
    # Check if the requested app number exists
    if [ ${#window_ids[@]} -lt $app_number ]; then
        exit 1
    fi
    
    # Get the window ID (arrays are 0-indexed, so subtract 1)
    local target_window_id=${window_ids[$((app_number - 1))]}
    
    # Get app info for notification
    local app_info=$(echo "$workspace_data" | jq -r --arg window_id "$target_window_id" '
        .[] | select(.id == ($window_id | tonumber)) | "\(.app_id): \(.title)"'
    )
    
    # Focus the window
    niri msg action focus-window --id "$target_window_id"
}

# Main function
main() {
    local action=$1
    local param=$2
    
    case "$action" in
        "focus")
            if [ -z "$param" ]; then
                exit 1
            fi
            focus_app_by_number "$param"
            ;;
        *)
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
