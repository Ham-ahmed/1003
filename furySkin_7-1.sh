#!/bin/sh

# ========================================================
# Fury-FHD Skin Installer Script
# ========================================================
# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
NC='\033[0m' # No Color

# Configuration
#########################################
plugin="fury-fhd"
git_url="https://raw.githubusercontent.com/Ham-ahmed/1003/refs/heads/main/furySkin_7-1"
version=$(wget $git_url/version -qO- | awk 'NR==1')
plugin_path="/usr/share/enigma2/Fury-FHD"
package="enigma2-plugin-skins-$plugin"
targz_file="$plugin.tar.gz"
url="$git_url/$targz_file"
temp_dir="/tmp"

# Determine package manager
#########################################
if command -v dpkg &> /dev/null; then
    package_manager="apt"
    status_file="/var/lib/dpkg/status"
    uninstall_command="apt-get purge --auto-remove -y"
    install_command="apt-get install -y"
else
    package_manager="opkg"
    status_file="/var/lib/opkg/status"
    uninstall_command="opkg remove --force-depends"
    install_command="opkg install"
fi

# Print banner
clear
echo "********************************************************"
echo "*                                                      *"
echo "*              ${GREEN}Fury-FHD Skin Installer${NC}                   *"
echo "*                                                      *"
echo "********************************************************"
echo ""

# Function: Check and remove old version
#########################################
check_and_remove_package() {
    echo "${YELLOW}> Checking for existing installations...${NC}"
    sleep 2
    
    # Remove directories if they exist
    if [ -d "$plugin_path" ]; then
        echo "${YELLOW}> Removing old skin directory...${NC}"
        rm -rf "$plugin_path" > /dev/null 2>&1
    fi
    
    # Remove additional Fury related files
    rm -rf /usr/lib/enigma2/python/Plugins/Extensions/Fury > /dev/null 2>&1
    rm -rf /usr/lib/enigma2/python/Components/fury* > /dev/null 2>&1
    rm -rf /usr/lib/enigma2/python/Components/Converter/fury* > /dev/null 2>&1
    rm -rf /usr/lib/enigma2/python/Components/Renderer/fury* > /dev/null 2>&1
    
    # Remove package via package manager if installed
    if grep -q "$package" "$status_file"; then
        echo "${YELLOW}> Removing old package: $package${NC}"
        $uninstall_command $package > /dev/null 2>&1
    fi
    
    echo "${GREEN}*******************************************${NC}"
    echo "${GREEN}*        Cleanup Finished                 *${NC}"
    echo "${GREEN}*******************************************${NC}"
    sleep 2
}

# Function: Install dependencies
#########################################
check_and_install_dependencies() {
    echo "${YELLOW}> Installing dependencies...${NC}"
    if [ "$package_manager" = "apt" ]; then
        $install_command enigma2-plugin-extensions-bitrate python3-pillow >/dev/null 2>&1
    else
        $install_command enigma2-plugin-extensions-bitrate python3-pillow >/dev/null 2>&1
    fi
    
    if [ $? -eq 0 ]; then
        echo "${GREEN}> Dependencies installed successfully.${NC}"
    else
        echo "${YELLOW}> Warning: Dependencies installation may have issues. Continuing anyway...${NC}"
    fi
    sleep 2
}

# Function: Download and install package
#########################################
download_and_install_package() {
    echo "${YELLOW}> Downloading $plugin-$version package...${NC}"
    sleep 2
    
    # Download the tar.gz file
    wget --show-progress -qO $temp_dir/$targz_file --no-check-certificate $url
    
    if [ $? -ne 0 ]; then
        echo "${RED}> Download failed. Please check your internet connection.${NC}"
        sleep 3
        return 1
    fi
    
    echo "${GREEN}> Download completed. Extracting...${NC}"
    
    # Extract the archive
    tar -xzf $temp_dir/$targz_file -C /
    extract=$?
    rm -rf $temp_dir/$targz_file >/dev/null 2>&1
    
    if [ $extract -eq 0 ]; then
        echo "${GREEN}> Extraction successful.${NC}"
        
        # Get box model and python version
        BOXMODEL=$(cat /etc/hostname 2>/dev/null || echo "unknown")
        if command -v python3 >/dev/null 2>&1; then
            PYVER=$(python3 --version 2>&1)
        elif command -v python >/dev/null 2>&1; then
            PYVER=$(python --version 2>&1)
        else
            PYVER="Python: Not installed"
        fi
        
        SKINDIR='/usr/share/enigma2/Fury-FHD'
        
        # Configure skin based on image type
        echo "${YELLOW}> Configuring skin for your image...${NC}"
        sleep 1
        
        # Check image type and copy appropriate logos
        if grep -qs -i "openATV" /etc/image-version; then
            mv -f "$SKINDIR/image_logo/openatv/imagelogo.png" "$SKINDIR" 2>/dev/null
            mv -f "$SKINDIR/image_logo/openatv/top_logo.png" "$SKINDIR" 2>/dev/null
            echo "${GREEN}> openATV detected.${NC}"
            
        elif grep -qs -i "egami" /etc/image-version; then
            mv -f "$SKINDIR/image_logo/egami/imagelogo.png" "$SKINDIR" 2>/dev/null
            mv -f "$SKINDIR/image_logo/egami/top_logo.png" "$SKINDIR" 2>/dev/null
            echo "${GREEN}> EGAMI detected.${NC}"
            
        elif grep -qs -i "PURE2" /etc/image-version; then
            mv -f "$SKINDIR/image_logo/pure2/imagelogo.png" "$SKINDIR" 2>/dev/null
            mv -f "$SKINDIR/image_logo/pure2/top_logo.png" "$SKINDIR" 2>/dev/null
            echo "${GREEN}> PURE2 detected.${NC}"
            
        elif grep -qs -i "OpenSPA" /etc/image-version; then
            mv -f "$SKINDIR/image_logo/openspa/imagelogo.png" "$SKINDIR" 2>/dev/null
            mv -f "$SKINDIR/image_logo/openspa/top_logo.png" "$SKINDIR" 2>/dev/null
            echo "${GREEN}> OpenSPA detected.${NC}"
            
        elif grep -qs -i "openBH" /etc/image-version; then
            mv -f "$SKINDIR/image_logo/openbh/imagelogo.png" "$SKINDIR" 2>/dev/null
            mv -f "$SKINDIR/image_logo/openbh/top_logo.png" "$SKINDIR" 2>/dev/null
            echo "${GREEN}> openBH detected.${NC}"
            
        elif grep -qs -i "openViX" /etc/image-version; then
            mv -f "$SKINDIR/image_logo/openvix/imagelogo.png" "$SKINDIR" 2>/dev/null
            mv -f "$SKINDIR/image_logo/openvix/top_logo.png" "$SKINDIR" 2>/dev/null
            echo "${GREEN}> openViX detected.${NC}"
            
        elif grep -qs -i "openDroid" /etc/image-version; then
            mv -f "$SKINDIR/image_logo/opendroid/imagelogo.png" "$SKINDIR" 2>/dev/null
            mv -f "$SKINDIR/image_logo/opendroid/top_logo.png" "$SKINDIR" 2>/dev/null
            echo "${GREEN}> openDroid detected.${NC}"
            
        elif grep -qs -i "openpli" /etc/issue; then
            if grep -qs -i "GCC-15.1" /etc/issue; then
                mv -f "$SKINDIR/image_logo/foxbob/imagelogo.png" "$SKINDIR" 2>/dev/null
                mv -f "$SKINDIR/image_logo/foxbob/top_logo.png" "$SKINDIR" 2>/dev/null
            else
                mv -f "$SKINDIR/image_logo/openpli/imagelogo.png" "$SKINDIR" 2>/dev/null
                mv -f "$SKINDIR/image_logo/openpli/top_logo.png" "$SKINDIR" 2>/dev/null
            fi
            echo "${GREEN}> openPLI detected.${NC}"
            
        elif grep -qs -i "Corvoboys" /etc/issue; then
            mv -f "$SKINDIR/image_logo/corvoboys/imagelogo.png" "$SKINDIR" 2>/dev/null
            mv -f "$SKINDIR/image_logo/corvoboys/top_logo.png" "$SKINDIR" 2>/dev/null
            echo "${GREEN}> Corvoboys detected.${NC}"
            
        elif grep -qs -i "TNAP" /etc/issue; then
            mv -f "$SKINDIR/image_logo/tnap/imagelogo.png" "$SKINDIR" 2>/dev/null
            mv -f "$SKINDIR/image_logo/tnap/top_logo.png" "$SKINDIR" 2>/dev/null
            echo "${GREEN}> TNAP detected.${NC}"
            
        elif grep -qs -i "foxbob" /etc/issue; then
            mv -f "$SKINDIR/image_logo/openplifoxbob/imagelogo.png" "$SKINDIR" 2>/dev/null
            mv -f "$SKINDIR/image_logo/openplifoxbob/top_logo.png" "$SKINDIR" 2>/dev/null
            echo "${GREEN}> Foxbob detected.${NC}"
            
        else
            # Default configuration
            cp -f "$SKINDIR/main/boximage.png" "$SKINDIR/boximage.png" 2>/dev/null
            cp -f "$SKINDIR/main/top_logo.png" "$SKINDIR/top_logo.png" 2>/dev/null
            echo "${YELLOW}> Generic image detected. Using default logos.${NC}"
        fi
        
        # Copy box image if available
        if [ -f "/usr/share/enigma2/${BOXMODEL}.png" ]; then
            cp -f "/usr/share/enigma2/${BOXMODEL}.png" "$SKINDIR/boximage.png" 2>/dev/null
            echo "${GREEN}> Box-specific logo applied.${NC}"
        fi
        
        # Clean up
        rm -rf "$SKINDIR/image_logo" > /dev/null 2>&1
        rm -rf /control /postinst /preinst /prerm /postrm > /dev/null 2>&1
        
        echo ""
        echo "${GREEN}************************************************${NC}"
        echo "${GREEN}*                                              *${NC}"
        echo "${GREEN}*  $plugin-$version installed successfully!  *${NC}"
        echo "${GREEN}*                                              *${NC}"
        echo "${GREEN}************************************************${NC}"
        sleep 3
        return 0
    else
        echo "${RED}> Installation failed: Extraction error.${NC}"
        sleep 3
        return 1
    fi
}

# Function: Final cleanup
#########################################
cleanup() {
    [ -d "/CONTROL" ] && rm -rf /CONTROL >/dev/null 2>&1
    rm -rf /control /postinst /preinst /prerm /postrm /tmp/*.ipk /tmp/*.tar.gz >/dev/null 2>&1
    echo "${BLUE}> Cleanup completed.${NC}"
}

# ========================================================
# Main script execution
# ========================================================
main() {
    # Step 1: Remove old version
    check_and_remove_package
    
    # Step 2: Install dependencies
    check_and_install_dependencies
    
    # Step 3: Download and install new version
    if ! download_and_install_package; then
        echo "${RED}> Installation failed. Exiting.${NC}"
        cleanup
        exit 1
    fi
    
    # Step 4: Final cleanup
    cleanup
    
    echo ""
    echo "${CYAN}=======================================================${NC}"
    echo "${CYAN}*  Please restart Enigma2 (GUI) to apply the new skin  *${NC}"
    echo "${CYAN}=======================================================${NC}"
    echo ""
}

# Run the main function
main
exit 0