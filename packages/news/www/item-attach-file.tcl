ad_page_contract {

	link one file to a news item
	




} {
	{item_id}
}

set user_id [ad_conn user_id]
set package_id [ad_conn package_id]
set news_item_id $item_id

ad_form -name news -export {item_id} -form {{publish_title:text(hidden)}} -html {enctype multipart/form-data}

##integration with videos package
set videos_package_id [site_node_apm_integration::get_child_package_id -package_id $package_id -package_key videos]

if {$videos_package_id != ""} {
	ad_form -extend -name news -form {
		{video_file:file,optional {label "#news.Videos#"} {help_text "[_ news.Video_text_info]"}}
	}
}

##integration with sounds package
set sounds_package_id [site_node_apm_integration::get_child_package_id -package_id $package_id -package_key sounds]

if {$sounds_package_id != ""} {
	ad_form -extend -name news -form {
		{sound_file:file,optional {label "#news.Sound#"} {help_text "[_ news.Sound_text_info]"} }
	}
}

##integration with file-storage package
set fs_package_id [site_node_apm_integration::get_child_package_id -package_id $package_id -package_key file-storage]

if {$fs_package_id != ""} {
	ad_form -extend -name news -form {
		{fs_file:file,optional {label "#news.File#"} {help_text "[_ news.File_text_info]"}}
	}
}

ad_form -extend -name news -on_request {
	db_1row select_item {}
}


ad_form -extend -name news -on_submit {
			

		if {[exists_and_not_null video_file]} {
			set upload_file [template::util::file::get_property filename $video_file]
			set upload_tmpfile [template::util::file::get_property tmp_filename $video_file]
			set mime_type [template::util::file::get_property mime_type $video_file]
			set item_id [videos::new -filename $upload_file \
				-tmp_filename $upload_tmpfile \
			    -name $publish_title \
			    -description "" \
			    -user_id $user_id \
			    -package_id $videos_package_id \
				-creation_ip ""]

			  application_data_link::new -this_object_id $news_item_id -target_object_id $item_id
		}

			 
		if {[exists_and_not_null sounds_file]} {
			set upload_file [template::util::file::get_property filename $sound_file]
			set upload_tmpfile [template::util::file::get_property tmp_filename $sound_file]
			set mime_type [template::util::file::get_property mime_type $sound_file]

			set n_bytes [file size $upload_tmpfile]
	
			set item_id [sounds::new -tmp_filename $upload_tmpfile \
			    -name $publish_title \
			    -n_bytes $n_bytes \
			    -guessed_file_type $mime_type \
			    -description $description \
			    -queue 1 \
			    -user_id $user_id \
			    -package_id $sounds_package_id]
			  application_data_link::new -this_object_id $news_item_id -target_object_id $item_id
		}

		if {[exists_and_not_null fs_file]} {			
			set upload_file [template::util::file::get_property filename $fs_file]
			set upload_tmpfile [template::util::file::get_property tmp_filename $fs_file]
			set mime_type [template::util::file::get_property mime_type $fs_file]
	
			set file_id [db_nextval "acs_object_id_seq"]


			set folder_id [fs::get_root_folder -package_id $fs_package_id]
			set revision_id [fs::add_file \
	    			-name $upload_file \
	    			-item_id $file_id \
	    			-parent_id $folder_id \
	    			-tmp_filename $upload_tmpfile \
	    			-creation_user $user_id \
	    			-creation_ip [ad_conn peeraddr] \
	    			-title $publish_title \
	    			-description "" \
	    			-package_id $fs_package_id \
            		-mime_type $mime_type]
		
			  set item_id [content::revision::item_id -revision_id $revision_id]
			  application_data_link::new -this_object_id $news_item_id -target_object_id $item_id
		}
	

}


ad_form -extend -name news -after_submit {
	# Flush the cache for both items
    util_memoize_flush_regexp "application_data_link::get_linked_content_not_cached -from_object_id $news_item_id *"
	ad_returnredirect "item?item_id=$item_id"
}
