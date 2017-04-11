#!/bin/bash

# Setting version of gitlab and dist wanted
dist="ubuntu/xenial"

# Where to get the packages from
URL=https://packages.gitlab.com/
# Where to get the versions from
# As this is ordered by release date, we'll get the latest versions first
VERSIONURL=https://packages.gitlab.com/gitlab/gitlab-ce

# Get the list of packages, then grep the distro name, then the first line, then whatever is between quotes (should be an href)
downloadUrl=`curl -s $VERSIONURL | grep "$dist" | head -n 1 | awk -F '"' '{print $2}'`
# Get the filename of the previous url
package=`echo $downloadUrl | sed 's/.*\///'`

# If we already downloaded the version, skip it
if test -f "./$package"; then
     echo "Version already exists !";
     exit 1;
fi

echo "Downloading $package..."
wget $URL/$downloadUrl/download -O $package

echo "Installing"

# This will only work on deb based systems
dpkg -i $package
# I think this will work for rpm based ones, is not tested
#rpm -Uvh $package

#echo "Reconfigure"
#gitlab-ctl reconfigure

echo "Restart"
gitlab-ctl restart

# Uncomment these lines if you want to get rid of the installation files and save some space
#rm -rf $package
#touch $package
