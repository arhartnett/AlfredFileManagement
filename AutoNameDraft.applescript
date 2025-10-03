set filePath to "{query}"


tell application "Finder"
	# use the query path if not empty, else use the selection
	if filePath is equal to "" then
		set theFile to selection as alias
	else
		set theFile to POSIX file filePath as alias
		
	end if
	
	set containingFolder to container of theFile as alias
	set thisItem to theFile
	
	set fileName to (name of thisItem as text)
	set fileExtension to name extension of thisItem
	
	set {year:y, month:m, day:d} to (current date)
	# pad the day and month if single digit
	set day_str to text -1 thru -2 of ("00" & d)
	set mon_str to text -1 thru -2 of ("00" & (m * 1))
	set yr_str to y as string
	set date_str to yr_str & mon_str & day_str
	
	set parentFolderReal to parent of thisItem
	set countSiblings to count (every file of parentFolderReal whose name extension is fileExtension)
	set versionNo to text -1 thru -3 of ("000" & countSiblings)
	
	set parentFolder to name of parent of thisItem
	set grandparentFolder to name of parent of parent of thisItem
	
	set thisItem's name to grandparentFolder & "_" & parentFolder & "_" & date_str & "_" & versionNo & "." & fileExtension
end tell