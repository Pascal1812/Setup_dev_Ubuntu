# Ubuntu Development Environment Setup

This repository contains a script to automatically set up a complete development environment on Ubuntu. The script installs and configures common development tools and utilities needed for various programming tasks.

## 🚀 Features

The script installs and configures:

- Visual Studio Code
- Docker & Docker Compose
- Ansible
- VirtualBox
- Vagrant
- Go (golang)
- Node.js & npm (with Yarn and Next.js)
- Java (OpenJDK)
- Python & pip (with virtualenv)

## 📋 Prerequisites

- Ubuntu Linux (20.04 LTS or newer)
- Sudo privileges
- Internet connection

## 🛠️ Installation

1. Clone this repository:
```bash
git clone git@github.com:Pascal1812/Setup_dev_Ubuntu.git
cd Setup_dev_Ubuntu
```

2. Make the script executable:
```bash
chmod +x setup_dev_env.sh
```

3. Run the script:
```bash
./setup_dev_env.sh
```

## 📝 Notes

- The script will create a log file in your home directory
- You'll need to log out and back in after installation for all changes to take effect

## ⚠️ Important

- Do not run this script as root or with sudo
- Make sure to read through the script before running it
- The script will prompt for sudo password when needed
- Some installations might require accepting license agreements

## 📜 Log Files

The script generates a log file in your home directory with the format:
```
dev_setup_YYYYMMDD_HHMMSS.log
```

## 🔍 Verification

After installation, the script will display the versions of all installed components for verification.

## 🤝 Contributing

Feel free to fork this repository and submit pull requests for any improvements.

## 🐛 Issues

If you encounter any problems, please file an issue in the GitHub issue tracker.

## ✨ Customization

You can modify the script to:
- Add or remove packages
- Change installation versions
- Modify default configurations
- Add additional development tools