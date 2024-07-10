#!/bin/bash


#Created by Dale Ribeiro on 9/18/19

# This script is designed to be run after the configuration profile to disable
# iCloud Drive is deployed to existing users. If a user has iCloud Desktop and
# Documents sync turned on, the files in ~/Desktop and ~/Documents are moved to
# ~/iCloud Drive Archive when the profile is installed. This gives the illusion
# to the user that the files in those locations have been deleted. This script
# copies the files from the Archive folder back to their original locations.


# Get the currently logged in user and assign it to a variable, so that it can be referenced later when 
# looking for the Archive folder and copying the files back to the user's home folder.
loggedInUser=$( scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ && ! /loginwindow/ { print $3 }' )

# Declare who the logged in user for debugging purposes. To confirm the previous line was successful.
echo "The logged in user is $loggedInUser"

# Define the iCloud folders variable located at ~/iCloud Drive (Archive). Will find if there are multiple (i.e. iCloud Drive Archive 2, etc.)
iCloudFolders=$(find "/Users/$loggedInUser" -name 'iCloud Drive (Archive)*' -type d -maxdepth 1)

# Checks to make sure the iCloud Drive Archive folder exists. If it doesn't the script will exit becuase there is nothing to do.
# If an iCloud Drive Archive folder is found, it will write the file path to /tmp/iCloudArchive.txt. This allows the script to handle
# multiple iCloud Drive Archive folders, in case the feature has been turned on and off multiple times in the past.

if [[  ! $iCloudFolders ]]; then
	echo "No iCloud Archive Folders found"
	exit 0
else
	echo "iCloud Archive Folders found! Checking for Desktop and Documents Folder..."
	echo "$iCloudFolders" >> /tmp/iCloudArchive.txt

# This is the key logic to the script. It reads the /tmp/iCloudArchive.txt and loops through each line and checks the folders to see if
# they have any files in them. If the files exist and are NOT empty, they will be copied back to either ~/Documents or ~/Desktop, based
# on their original file location.
	while IFS= read -r line
	do
		if [ -d "$line"/Desktop/ ]; then
			echo "Desktop folder found in $line, checking to see if there are files to copy..."
				if [ "$(ls "$line"/Desktop)" ]; then
					mv -v "$line"/Desktop/* /Users/"$loggedInUser"/Desktop
				else
					echo "The Desktop folder in $line is empty"
				fi
		else
			echo "Desktop Folder Not found in $line"
		fi
		if [ -d "$line"/Documents/ ]; then
			echo "Documents folder found in $line, checking to see if there are files to copy..."
				if [ "$(ls "$line"/Documents)" ]; then
					mv -v "$line"/Documents/* /Users/"$loggedInUser"/Documents
				else
					echo "The Documents folder in $line is empty"
				fi
		else
			echo "Documents Folder Not Found in $line"
		fi
	done < /tmp/iCloudArchive.txt
fi

# Remove the /tmp/iCloudArchive.txt folder as it is no longer needed.
rm /tmp/iCloudArchive.txt

exit 0
