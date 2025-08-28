shreya_11@LAPTOP-GO75PN97:~/projects/user-mgmt-backup$ cat user_mgmt_backup.sh
#!/usr/bin/env bash
# User Management & Backup Tool
# Version: 1.0.0
set -euo pipefail

VERSION="1.0.0"
LOG_FILE="/var/log/user_mgmt_backup.log"
DEFAULT_BACKUP_DIR="/var/backups"

# --- Helper functions ---
require_root() {
    if [[ "$EUID" -ne 0 ]]; then
        echo "This script must be run as root (use sudo)."
        exit 1
    fi
}

setup() {
    mkdir -p "$(dirname "$LOG_FILE")" "$DEFAULT_BACKUP_DIR"
    touch "$LOG_FILE"
    chmod 600 "$LOG_FILE"
}

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"
}

command_exists() {
    command -v "$1" &>/dev/null
}

pause() {
    read -rp "Press Enter to continue..." _
}

# --- User Management Functions ---
add_user_flow() {
    echo "== Add User =="
    read -rp "Enter new username: " u
    if id "$u" &>/dev/null; then
        echo "User $u already exists."
        return
    fi
    read -rp "Enter shell [/bin/bash]: " shell
    shell=${shell:-/bin/bash}
    sudo useradd -m -s "$shell" "$u"
    echo "User $u created."
    log "Added user $u"
}

delete_user_flow() {
    echo "== Delete User =="
    read -rp "Enter username to delete: " u
    if ! id "$u" &>/dev/null; then
        echo "User $u does not exist."
        return
    fi
    sudo userdel -r "$u"
    echo "User $u deleted."
    log "Deleted user $u"
}

modify_user_flow() {
    echo "== Modify User =="
    read -rp "Enter username to modify: " u
    if ! id "$u" &>/dev/null; then
        echo "User $u does not exist."
        return
    fi
    read -rp "Enter new shell (leave blank to skip): " shell
    if [[ -n "$shell" ]]; then
        sudo usermod -s "$shell" "$u"
        echo "Shell for $u updated."
        log "Changed shell for $u"
    fi
}

group_mgmt_flow() {
    echo "== Group Management =="
    echo "1) Create group"
    echo "2) Delete group"
    read -rp "Enter choice: " gchoice
    case "$gchoice" in
        1)
            read -rp "Enter new group name: " g
            sudo groupadd "$g"
            echo "Group $g created."
            log "Created group $g"
            ;;
        2)
            read -rp "Enter group name to delete: " g
            sudo groupdel "$g"
            echo "Group $g deleted."
            log "Deleted group $g"
            ;;
        *)
            echo "Invalid choice."
            ;;
    esac
}

# --- Backup Functions ---
backup_flow() {
    echo "== Backup =="
    read -rp "Enter directory to backup: " dir
    if [[ ! -d "$dir" ]]; then
        echo "Directory $dir not found."
        return
    fi
    read -rp "Enter destination directory [$DEFAULT_BACKUP_DIR]: " dest
    dest=${dest:-$DEFAULT_BACKUP_DIR}
    mkdir -p "$dest"

    archive="$dest/$(basename "$dir")$(date +%Y%m%d%H%M%S).tar.gz"
    tar -czf "$archive" "$dir"
    sha256sum "$archive" > "${archive}.sha256"

    echo "Backup saved to: $archive"
    echo "Checksum saved to: ${archive}.sha256"
    log "Backup of $dir saved to $archive"
}

verify_backup_flow() {
    echo "== Verify Backup =="
    read -rp "Path to backup .tar.gz file: " f
    if [[ ! -f "$f" || ! -f "${f}.sha256" ]]; then
        echo "Backup or .sha256 file not found."
        return
    fi
    if sha256sum -c "${f}.sha256"; then
        echo "Backup OK."
        log "Verified backup $f OK"
    else
        echo "Backup CORRUPTED!"
        log "Backup $f FAILED verification"
    fi
}

# --- Menu and Main ---
show_menu() {
    clear
    cat <<EOF
====================================================
User Management & Backup Tool (v$VERSION)
====================================================
Choose an option:
1) Add user
2) Delete user
3) Modify user
4) Group management
5) Backup a directory
6) Verify a backup
7) Exit
EOF
}

check_deps() {
    local missing=()
    for cmd in useradd userdel usermod groupadd groupdel id getent tar sha256sum; do
        command_exists "$cmd" || missing+=("$cmd")
    done
    if ((${#missing[@]})); then
        echo "Missing required commands: ${missing[*]}"
        echo "Install them with your package manager (they are usually part of 'passwd', 'shadow' and 'tar')."
        exit 1
    fi
}

main() {
    require_root
    setup
    check_deps
    while true; do
        show_menu
        read -rp "Enter choice [1-7]: " choice
        case "$choice" in
            1) add_user_flow; pause ;;
            2) delete_user_flow; pause ;;
            3) modify_user_flow; pause ;;
            4) group_mgmt_flow; pause ;;
            5) backup_flow; pause ;;
            6) verify_backup_flow; pause ;;
            7) echo "Goodbye!"; exit 0 ;;
            *) echo "Please choose a number between 1 and 7."; pause ;;
        esac
    done
}

main "$@"
