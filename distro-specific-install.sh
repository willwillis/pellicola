#!/usr/bin/env bash

# Author: Will Willis, will.willis@gmail.com
# Enhanced with multi-distribution support

#######################################################################
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#######################################################################

# Don't start as root
if [[ $EUID -eq 0 ]]; then
   echo "Run the script as a regular user"
   exit 1
fi

# Detect the operating system
detect_os() {
    OS="$(uname -s)"
    case "${OS}" in
        Linux*)     MACHINE=Linux;;
        Darwin*)    MACHINE=Mac;;
        CYGWIN*)    MACHINE=Cygwin;;
        MINGW*)     MACHINE=MinGw;;
        *)          MACHINE="UNKNOWN:${OS}"
    esac
    echo "Operating System: ${MACHINE}"
}

# Determine package manager based on available binaries
determine_package_manager() {
    if [ "$MACHINE" != "Linux" ]; then
        echo "This script only supports Linux systems."
        exit 1
    fi
    
    # Check for package manager binaries
    if command -v apt-get >/dev/null 2>&1; then
        echo "Likely package manager: APT (Debian/Ubuntu)"
        PACKAGE_MANAGER="apt"
    elif command -v dnf >/dev/null 2>&1; then
        echo "Likely package manager: DNF (Fedora/RHEL)"
        PACKAGE_MANAGER="dnf"
    elif command -v yum >/dev/null 2>&1; then
        echo "Likely package manager: YUM (CentOS/RHEL older)"
        PACKAGE_MANAGER="yum"
    elif command -v pacman >/dev/null 2>&1; then
        echo "Likely package manager: Pacman (Arch Linux)"
        PACKAGE_MANAGER="pacman"
    elif command -v apk >/dev/null 2>&1; then
        echo "Likely package manager: APK (Alpine Linux)"
        PACKAGE_MANAGER="apk"
    elif command -v zypper >/dev/null 2>&1; then
        echo "Likely package manager: Zypper (openSUSE)"
        PACKAGE_MANAGER="zypper"
    else
        echo "No common package manager found or identified."
        PACKAGE_MANAGER="unknown"
    fi
}

# Install packages based on detected package manager
install_packages() {
    case $PACKAGE_MANAGER in
        "apt")
            echo "Installing packages using apt..."
            # Update source and perform the full system upgrade
            sudo apt update
            sudo apt full-upgrade -y
            sudo apt update
            
            # Install the required packages
            sudo apt install -y apache2 php php-gd php-common git rsync
            
            # Remove obsolete packages
            sudo apt autoremove -y
            ;;
            
        "pacman")
            echo "Installing packages using pacman..."
            # Update system
            sudo pacman -Syu --noconfirm
            
            # Install the required packages
            sudo pacman -S --noconfirm apache php php-gd git rsync
            
            # Enable and start Apache
            sudo systemctl enable httpd
            sudo systemctl start httpd
            ;;
            
        "dnf")
            echo "Installing packages using dnf..."
            # Update system
            sudo dnf update -y
            
            # Install the required packages
            sudo dnf install -y httpd php php-gd git rsync
            
            # Enable and start Apache
            sudo systemctl enable httpd
            sudo systemctl start httpd
            ;;
            
        "yum")
            echo "Installing packages using yum..."
            # Update system
            sudo yum update -y
            
            # Install the required packages
            sudo yum install -y httpd php php-gd git rsync
            
            # Enable and start Apache
            sudo systemctl enable httpd
            sudo systemctl start httpd
            ;;
            
        "apk")
            echo "Installing packages using apk..."
            # Update system
            sudo apk update
            
            # Install the required packages
            sudo apk add apache2 php php-gd git rsync
            
            # Enable and start Apache
            sudo rc-update add apache2 default
            sudo rc-service apache2 start
            ;;
            
        "zypper")
            echo "Installing packages using zypper..."
            # Update system
            sudo zypper update -y
            
            # Install the required packages
            sudo zypper install -y apache2 php php-gd git rsync
            
            # Enable and start Apache
            sudo systemctl enable apache2
            sudo systemctl start apache2
            ;;
            
        "unknown")
            echo "Unsupported package manager. Please install the following packages manually:"
            echo "- Web server (Apache/httpd)"
            echo "- PHP with GD extension"
            echo "- Git"
            echo "- rsync"
            echo ""
            echo "Then run the script again to continue with Pellicola installation."
            exit 1
            ;;
    esac
}

# Set correct permissions based on package manager
set_permissions() {
    case $PACKAGE_MANAGER in
        "pacman")
            # Arch Linux uses http user
            sudo chown http:http -R /var/www/html/
            ;;
        "apk")
            # Alpine Linux typically uses apache user
            sudo chown apache:apache -R /var/www/html/
            ;;
        "zypper")
            # openSUSE typically uses wwwrun user
            sudo chown wwwrun:wwwrun -R /var/www/html/
            ;;
        *)
            # Debian/Ubuntu/RHEL use www-data
            sudo chown www-data:www-data -R /var/www/html/
            ;;
    esac
}

# Main installation process
main() {
    echo "Pellicola Installer"
    echo "=================="
    echo ""
    
    # Detect operating system
    detect_os
    
    # Determine package manager
    determine_package_manager
    
    # Install packages
    install_packages
    
    # Clone the Git repo
    cd
    git clone https://github.com/dmpop/pellicola.git
    
    # Copy Pellicola to the document root
    rsync -avh --delete --progress pellicola/ /var/www/html
    
    # Set the correct permissions
    set_permissions
    
    echo ""
    echo "Installation completed successfully!"
    echo "You can now access Pellicola at: http://localhost"
    echo ""
    echo "Note: Make sure to configure your web server and PHP settings as needed."
}

# Run main function
main
