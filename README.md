# Move-iCloud-Archive-Folders
A simple script to copy files back to their original locations after iCloud Desktop and Documents sync has been turned off.

As with all scripts, please review before deploying to make sure you understand what is being done here. This script will move files when it is run.

This script is designed to be run after the configuration profile to disable
Cloud Drive is deployed to existing users. If a user has iCloud Desktop and
Documents sync turned on, the files in ~/Desktop and ~/Documents are moved to
~/iCloud Drive Archive when the profile is installed. This gives the illustion
to the user that the files in those locations have been deleted. This script
copies the files from the Archive fodler back to their original locations.
