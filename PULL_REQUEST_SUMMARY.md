# New Multi-Distribution Installer Script

## Summary

This PR introduces a new installer script that supports multiple Linux distributions beyond the original Debian/Ubuntu-only `install.sh`. The new script automatically detects and supports 6 major Linux distributions with their native package managers while maintaining the same simple installation process.

## New File: `distro-specific-install.sh`

**Alternative file name suggestions:**
- `distro-specific-install.sh` ⭐ (recommended - clear and descriptive)
- `install-multi-linux.sh`
- `install-linux.sh` 
- `install-multi.sh`
- `install-cross-distro.sh`
- `install-enhanced.sh`

## Changes Made

### 🔧 **Improved System Detection**
- **Original**: Only detected Debian/Ubuntu systems via `apt` presence
- **New**: Uses `uname -s` to detect OS, then checks for package manager binaries
- **Benefit**: More reliable detection that works even with multiple package managers installed

### 🎯 **Enhanced Package Manager Support**
Added support for:
- **Arch Linux**: `pacman` package manager
- **Fedora/RHEL**: `dnf` package manager  
- **CentOS/RHEL**: `yum` package manager
- **Alpine Linux**: `apk` package manager
- **openSUSE**: `zypper` package manager
- **Debian/Ubuntu**: `apt` package manager (same as original)

### 🏗️ **Distribution-Specific Adaptations**
- **Arch Linux**: Uses `apache` package name and `http` user
- **Alpine Linux**: Uses `rc-service` for service management and `apache` user
- **openSUSE**: Uses `wwwrun` user for file permissions
- **RHEL/Fedora**: Uses `httpd` package name
- **Debian/Ubuntu**: Uses `apache2` and `www-data` user (same as original)

### 📝 **Improved Code Structure**
- Separated concerns: `detect_os()`, `determine_package_manager()`, `install_packages()`, `set_permissions()`
- Clear function names that match their purpose
- Better error handling and user feedback
- Consistent case statements for maintainability

## File Comparison

| Feature | `install.sh` (original) | `distro-specific-install.sh` (new) |
|---------|------------------------|------------------------------|
| **Supported OS** | Debian/Ubuntu only | 6 Linux distributions |
| **Detection Method** | `apt` presence | `uname -s` + package manager binaries |
| **Code Structure** | Linear script | Modular functions |
| **Error Handling** | Basic | Enhanced with clear messages |
| **Maintenance** | Simple but limited | More complex but extensible |

## Backward Compatibility

✅ **Original `install.sh` unchanged** - Existing users and documentation remain valid
✅ **Same installation process** - Users follow the same steps as before
✅ **No breaking changes** - All existing functionality preserved

## Usage

### For Debian/Ubuntu Users
```bash
# Original installer (unchanged)
curl -sSL https://raw.githubusercontent.com/dmpop/pellicola/main/install.sh | bash

# New distro-specific installer
curl -sSL https://raw.githubusercontent.com/dmpop/pellicola/main/distro-specific-install.sh | bash
```

### For Other Linux Distributions
```bash
# Only the new installer works
curl -sSL https://raw.githubusercontent.com/dmpop/pellicola/main/distro-specific-install.sh | bash
```

## Testing Checklist

### Required Testing Environments

#### 🐧 **Debian/Ubuntu Systems**
- [ ] **Ubuntu 22.04 LTS**
  - [ ] Fresh installation
  - [ ] System with existing packages
  - [ ] Verify `apache2` package installed
  - [ ] Verify `www-data` user permissions
  - [ ] Verify Apache service starts correctly
  - [ ] Verify PHP with GD extension works
  - [ ] **Compare with original `install.sh`** - should produce identical results

- [ ] **Debian 12 (Bookworm)**
  - [ ] Fresh installation
  - [ ] System with existing packages
  - [ ] Verify `apache2` package installed
  - [ ] Verify `www-data` user permissions
  - [ ] Verify Apache service starts correctly
  - [ ] **Compare with original `install.sh`** - should produce identical results

- [ ] **Ubuntu 20.04 LTS**
  - [ ] Fresh installation
  - [ ] Verify backward compatibility with original installer

#### 🏔️ **Arch Linux Systems**
- [ ] **Arch Linux (latest)**
  - [ ] Fresh installation
  - [ ] System with existing packages
  - [ ] Verify `apache` package installed (not `apache2`)
  - [ ] Verify `http` user permissions (not `www-data`)
  - [ ] Verify `httpd` service starts correctly
  - [ ] Verify PHP with GD extension works

- [ ] **Manjaro**
  - [ ] Fresh installation
  - [ ] System with existing packages
  - [ ] Verify package installation works
  - [ ] Verify service management works

#### 🔴 **Red Hat Family**
- [ ] **Fedora 38/39**
  - [ ] Fresh installation
  - [ ] System with existing packages
  - [ ] Verify `httpd` package installed
  - [ ] Verify `www-data` user permissions
  - [ ] Verify `httpd` service starts correctly

- [ ] **CentOS 9 Stream**
  - [ ] Fresh installation
  - [ ] System with existing packages
  - [ ] Verify `httpd` package installed
  - [ ] Verify service management works

- [ ] **RHEL 9**
  - [ ] Fresh installation
  - [ ] Verify `dnf` package manager detection
  - [ ] Verify package installation works

#### 🏔️ **Alpine Linux**
- [ ] **Alpine Linux 3.18/3.19**
  - [ ] Fresh installation
  - [ ] System with existing packages
  - [ ] Verify `apache2` package installed
  - [ ] Verify `apache` user permissions
  - [ ] Verify `rc-service` service management works
  - [ ] Verify PHP with GD extension works

#### 🦎 **openSUSE**
- [ ] **openSUSE Leap 15.5**
  - [ ] Fresh installation
  - [ ] System with existing packages
  - [ ] Verify `apache2` package installed
  - [ ] Verify `wwwrun` user permissions
  - [ ] Verify `apache2` service starts correctly

- [ ] **openSUSE Tumbleweed**
  - [ ] Fresh installation
  - [ ] Verify package installation works
  - [ ] Verify service management works

### Edge Case Testing

#### 🔄 **Multiple Package Managers**
- [ ] **Arch system with apt installed**
  - [ ] Verify `pacman` is detected (not `apt`)
  - [ ] Verify correct packages installed

- [ ] **Ubuntu system with pacman installed**
  - [ ] Verify `apt` is detected (not `pacman`)
  - [ ] Verify correct packages installed

#### 🐳 **Container Environments**
- [ ] **Docker containers**
  - [ ] Ubuntu container
  - [ ] Alpine container
  - [ ] Arch container
  - [ ] Verify installation works in containers

#### 🚫 **Unsupported Systems**
- [ ] **macOS**
  - [ ] Verify script exits gracefully with helpful message
  - [ ] Verify no partial installation occurs

- [ ] **Windows (WSL)**
  - [ ] Verify detection works correctly
  - [ ] Verify installation works in WSL environment

### Functional Testing

#### 📦 **Package Installation**
- [ ] All required packages install correctly
- [ ] No package conflicts occur
- [ ] PHP GD extension is available
- [ ] Apache/httpd starts without errors

#### 🔐 **Permissions**
- [ ] Web server can read files in `/var/www/html/`
- [ ] Correct user/group ownership is set
- [ ] No permission errors in web server logs

#### 🌐 **Web Server**
- [ ] Apache/httpd service starts automatically
- [ ] Service persists across reboots
- [ ] No configuration conflicts

#### 📁 **File Operations**
- [ ] Git clone works correctly
- [ ] rsync copies files without errors
- [ ] All Pellicola files are in correct location

### Error Handling Testing

#### ❌ **Missing Dependencies**
- [ ] Script handles missing git gracefully
- [ ] Script handles missing rsync gracefully
- [ ] Clear error messages provided

#### 🔒 **Permission Issues**
- [ ] Script handles insufficient sudo privileges
- [ ] Script handles read-only filesystem gracefully

#### 🌐 **Network Issues**
- [ ] Script handles git clone failures gracefully
- [ ] Clear error messages for network problems

## How to Test

### Quick Test Commands
```bash
# Test on different distributions
# Ubuntu/Debian
docker run -it ubuntu:22.04 bash
# Alpine
docker run -it alpine:latest sh
# Arch
docker run -it archlinux:latest bash
```

### Manual Verification Steps
1. Run the installer script
2. Check package installation: `dpkg -l | grep apache` (Debian) or `pacman -Q | grep apache` (Arch)
3. Check service status: `systemctl status apache2` or `systemctl status httpd`
4. Check permissions: `ls -la /var/www/html/`
5. Verify web access: `curl http://localhost`

### Comparison Testing
```bash
# Test original installer on Ubuntu
curl -sSL https://raw.githubusercontent.com/dmpop/pellicola/main/install.sh | bash

# Test new installer on Ubuntu (should produce same result)
curl -sSL https://raw.githubusercontent.com/dmpop/pellicola/main/distro-specific-install.sh | bash

# Compare outputs and installed packages
```

## Breaking Changes

❌ **None** - Original `install.sh` remains unchanged

## Migration Guide

### For Existing Users
- **No action required** - Original installer continues to work
- **Optional upgrade** - Can switch to new installer for better error handling

### For New Users
- **Debian/Ubuntu**: Can use either installer
- **Other distributions**: Must use new installer

## Future Enhancements

Potential future improvements (not included in this PR):
- Support for Nginx as alternative web server
- Interactive configuration during installation
- Custom installation directory option
- Support for additional distributions (Gentoo, Slackware, etc.)
- Merge functionality into original `install.sh` after thorough testing

### 🎯 **Interactive Features (Future)**
- **Interactive package manager selection**: Allow users to choose package manager if multiple are detected
- **Command-line parameters**: Support `--distro` and `--package-manager` flags for advanced users
- **Confirmation prompts**: Ask user to confirm detected system before proceeding
- **Dry-run mode**: Show what would be installed without actually installing

### 💡 **Example Future Usage**
```bash
# Interactive mode (default)
./distro-specific-install.sh

# Non-interactive with parameters
./distro-specific-install.sh --distro Arch --package-manager pacman

# Dry-run mode
./distro-specific-install.sh --dry-run

# Force specific package manager
./distro-specific-install.sh --package-manager apt
```

**Note**: These features would add complexity, so they're planned for future versions after the basic multi-distro support is thoroughly tested and stable.

## Documentation Updates Needed

- [ ] Update README.md to mention the new installer
- [ ] Add installation instructions for non-Debian distributions
- [ ] Update installation documentation to recommend appropriate installer
- [ ] Add troubleshooting section for different distributions

---

**Note**: This approach provides a safe path forward by introducing enhanced functionality in a separate file while preserving the original installer for existing users. 