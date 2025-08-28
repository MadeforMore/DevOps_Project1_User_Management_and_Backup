# DevOps_Project1_User_Management_and_Backup
Shell Script for User Management and Backup in Linux 

---

Got it ✅ You want me to split your full guide into two neat parts:

1. **All Commands** (just the terminal commands to copy-paste step by step).
2. **Detailed README.md** (the explanation, features, usage, troubleshooting, etc. for GitHub).

Here’s the split:

---

# 🔹 Part 1 — All Commands

```bash
# --- Step 0: Quick Checks ---
whoami
bash --version
git --version || sudo apt install -y git
sudo apt update
sudo apt install -y git tar passwd

# --- Step 1: Make project folder ---
mkdir -p ~/projects/user-mgmt-backup
cd ~/projects/user-mgmt-backup

# --- Step 2: Create script file ---
nano user_mgmt_backup.sh   # (paste script content here)

# --- Step 3: Make executable ---
chmod +x user_mgmt_backup.sh

# --- Step 4: Run script with root ---
sudo ./user_mgmt_backup.sh

# --- Step 5A: Add User Example ---
# From menu -> Add user (username = testuser)

# --- Step 5B: Create Group Example ---
# From menu -> Group management -> Create group 'devs'
# Modify user -> Add to group -> testuser -> devs

# --- Step 5C: Backup Example ---
mkdir -p ~/demo && echo hi > ~/demo/hello.txt
# From menu -> Backup directory -> ~/demo

# --- Step 5D: Verify Backup Example ---
# From menu -> Verify backup -> path of .tar.gz file

# --- Step 7: Initialize GitHub Repo ---
git init
printf "# User Management & Backup\n" > README.md
echo "*.tar.gz" >> .gitignore
echo "*.sha256" >> .gitignore
echo "*.log" >> .gitignore

git add user_mgmt_backup.sh README.md .gitignore
git commit -m "feat: user management & backup script v1"

git branch -M main
git remote add origin https://github.com/<YOUR-USERNAME>/user-mgmt-backup.git
git push -u origin main
```

---

# 🔹 Part 2 

````markdown
# User Management & Backup (Bash)

A simple interactive Bash tool to manage Linux users/groups and create verified backups.

---

## 🚀 Features
- Add, delete, and modify users (lock/unlock, change shell, group membership)
- Create and delete groups
- Back up any directory into `.tar.gz` archives
- Verify backups with SHA256 checksums
- Centralized logging (`/var/log/user_mgmt_backup.log`)
- Clean, menu-driven CLI

---

## 📦 Requirements
Linux system with these tools installed:
- `bash`
- `useradd`, `usermod`, `userdel`
- `groupadd`, `groupdel`
- `tar`, `sha256sum`
- `passwd`

---

## ⚡ Usage
Run the script as root (sudo):

```bash
sudo ./user_mgmt_backup.sh
````

Menu options:

1. Add user
2. Delete user
3. Modify user
4. Group management
5. Backup a directory
6. Verify a backup
7. Exit

---

## 🔐 Security & Safety

* Root permission check
* Username validation
* Delete confirmation prompts
* Backups include `.sha256` checksum
* Logs are stored with `0600` permissions (only root can read/write)

---

## 🧪 Testing (Examples)

### Add a User

```bash
# Menu -> 1) Add user
Username: testuser
```

### Create & Manage Groups

```bash
# Menu -> 4) Create group 'devs'
# Menu -> 3) Modify user -> Add testuser to devs
```

### Backup a Folder

```bash
mkdir -p ~/demo && echo hi > ~/demo/hello.txt
# Menu -> 5) Backup directory -> ~/demo
```

### Verify a Backup

```bash
# Menu -> 6) Verify backup -> provide path of .tar.gz
```

---

## 🧰 Troubleshooting

* **“This script must be run as root”** → Use `sudo ./user_mgmt_backup.sh`
* **“command not found”** → Install missing tools (`sudo apt install -y passwd tar`)
* **Username already exists** → Use another name or delete the old one
* **Permission denied (log/backups)** → Run with `sudo`

---

## 🌱 Resume Bullets
```
* Built a Linux shell script to automate user & group management and backups.
* Implemented verified backups with compression and checksums.
* Practiced Git/GitHub for version control and reproducibility.

```


