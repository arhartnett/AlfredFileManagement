on run argv
	try
		# Get file path from argv or Finder selection
		if (count of argv) > 0 then
			set filePath to item 1 of argv
			set theFile to POSIX file filePath as alias
		else
			tell application "Finder"
				if (count of selection) is 0 then
					display dialog "No file selected" buttons {"OK"} default button 1
					return
				end if
				set theFile to item 1 of selection as alias
			end tell
		end if
		
		# Convert to POSIX path for System Events
		set filePOSIXPath to POSIX path of theFile
		
		# Use System Events for file info (more reliable than Finder)
		tell application "System Events"
			set fileItem to item filePOSIXPath
			set fileName to name of fileItem
			set fileExtension to name extension of fileItem
			
			# Get parent folder info
			set parentFolder to container of fileItem
			set parentFolderName to name of parentFolder
			set parentPath to POSIX path of parentFolder
			
			# Get grandparent folder info
			set grandparentFolder to container of parentFolder
			set grandparentFolderName to name of grandparentFolder
		end tell
		
		# Generate date string
		set {year:y, month:m, day:d} to (current date)
		set day_str to text -2 thru -1 of ("0" & d)
		set mon_str to text -2 thru -1 of ("0" & (m as integer))
		set yr_str to y as string
		set date_str to yr_str & mon_str & day_str
		
		# Count siblings using System Events
		tell application "System Events"
			set parentFolderObj to folder parentPath
			if fileExtension is not "" then
				set siblingFiles to every file of parentFolderObj whose name extension is fileExtension
			else
				set siblingFiles to every file of parentFolderObj
			end if
			set countSiblings to count of siblingFiles
		end tell
		
		set versionNo to text -3 thru -1 of ("00" & countSiblings)
		
		# Build new name
		set newName to grandparentFolderName & "_" & parentFolderName & "_" & date_str & "_" & versionNo
		if fileExtension is not "" then
			set newName to newName & "." & fileExtension
		end if
		
		# Use System Events to rename
		tell application "System Events"
			set fileItem to item filePOSIXPath
			set name of fileItem to newName
		end tell
		
		return newName
		
	on error errMsg number errNum
		display dialog "Error: " & errMsg & " (Code: " & errNum & ")" buttons {"OK"} default button 1 with icon stop
		return ""
	end try
end run