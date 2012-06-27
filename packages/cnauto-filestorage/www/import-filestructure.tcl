ad_page_contract {
    Imports file structure from filesystem
    
    1. level: Outlook
    
    Techit - MessageSave / EZDettach
    To save the emails and the attachments as files within a file structure hierarchy. The objetive is to save the files and directories in a network shared hard drive and use  openACS to read and manage those files.
    
    http://www.techhit.com/messagesave/
    
    2. Look at filestorage and Intranet FS is implemented and create cnauto-filestorage package to read the files and directory structure and repliacate it on OpenACS

} {
    {return_url ""}
}



set root_dir [parameter::get -parameter FileStorageRootDir -package_id [ad_conn package_id] -default ""]




namespace eval cn_filestorage {}

ad_proc -public browse_folders {
    {-item:required}
    {-action "read"}
} {
    browse folders, subfolders and files in the file system
} {

    if {$item ne ""} {
	if {[file isdirectory $item]} {
	    ns_log notice "FOLDER $item"
	    if {$action eq "create"} {
		#Create Folder
		# Analyse how we are going to integrate emails - filesystem - filestorage database
		# Use file-storage package, content items
	    }
	    
 	    if {[catch { set items [glob ${item}/*]} errorMsg]} {
		ns_log Notice "empty Diretory!!!"
		return 
	    } else {
		
		foreach item $items {
		    browse_folders -item $item -action $action
		}
	    }
	} elseif {[file isfile $item]} {
	    if {$action eq "create"} {
		# Create file
		# Analyse how we are going to integrate emails - filesystem - filestorage database
		# Use file-storage package, content items
	    }
	    ns_log notice "FILE $item"	    
	    return
	} else {		
	    ns_log Notice "root Diretory does not exists!!!"
	    return
	}	
    }
    
    return
}



 
    
browse_folders -item $root_dir -action "read"
    




ad_returnredirect $return_url
ad_script_abort