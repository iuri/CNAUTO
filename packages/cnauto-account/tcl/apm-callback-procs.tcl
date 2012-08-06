ad_library {
    
    CN Auto Account Package APM callback proc's library

    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    @creation-date 2011-11-04
}

namespace eval cn_account::install {}



ad_proc -private cn_account::install::after_mount {
    {-package_id }
} {
    
    After Mount  proc
    Creates folder structure for account package
} {
    
    ns_log Notice "Running ad_proc cn_account::install::after_install"
    
    
    
    util_memoize_flush_pattern [list cn_account::get_project_folder_id_not_cached -package_id $package_id]
    set parent_id [db_string parent_id "select parent_id from im_projects where project_id=:project_id" -default ""]
    
    if {$parent_id eq ""} { 
        # get the folder id of the intranet projects root dir, which is  'projects'
        # Assume we are using the first file-storage instance we can find for that
	set package_id [db_string get_package_id " select package_id from apm_packages where package_key = 'file-storage' limit 1" ]
	set root_folder_id [fs::get_root_folder -package_id $package_id]
	set parent_folder_id [fs::get_folder -name "projects" -parent_id $root_folder_id]
    } else { 
	set parent_folder_id [db_list get_folder_id { select object_id_two from acs_rels where object_id_one = :parent_id and rel_type = 'project_folder'}]
        
	if {$parent_folder_id eq ""} {
            # Recursively create the folders
            intranet_fs::create_project_folder -project_id $parent_id
        }
    }
    
    set project_name [db_string project_name "select project_name from im_projects where project_id = $project_id" -default ""]
    set folder_name [string tolower [util_text_to_url -text $project_name]]
    
    # If the parend_folder_id is empty then we usually us -100 for parent
    if {$parent_folder_id ne ""} {
	set folder_id [db_string folder_id "select item_id from cr_items where name = :folder_name and parent_id = :parent_folder_id" -default ""]
    } else {
	set folder_id [db_string folder_id "select item_id from cr_items where name = :folder_name and parent_id = -100" -default ""]
    }
    if {$folder_id eq ""} {
	set folder_id [fs::new_folder \
                           -name $folder_name \
                           -pretty_name $project_name \
			   -parent_id $parent_folder_id
		      ]
    }
    set rel_id [relation_add "project_folder" $project_id $folder_id]
    callback intranet_fs::after_project_folder_create -project_id $project_id -folder_id $folder_id
    
    return $folder_id
}
