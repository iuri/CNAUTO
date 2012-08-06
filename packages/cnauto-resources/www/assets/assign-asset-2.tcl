ad_page_contract {} {
    {user_id}
    {asset_id}
    {return_url ""}
    {confirm 0}
}
set myform [ns_getform]
if {[string equal "" $myform]} {
    ns_log Notice "No Form was submited"
} else {
    ns_log Notice "FORM"
    ns_set print $myform
}



ns_log Notice "$confirm"
switch $confirm {
    0 {
	db_1row select_user {
	    SELECT u.user_id || ' - ' || first_names || ' ' || last_name AS owner 
	    FROM cn_asset_user_map caum, cc_users u
	    WHERE asset_id = :asset_id
	    AND u.user_id = caum.user_id
	}
    }
    1 {
	cn_assets::asset::unassign_user \
	    -asset_id $asset_id 

	cn_assets::asset::assign_user \
	    -asset_id $asset_id \
	    -user_id $user_id    
	
	ad_returnredirect $return_url
	ad_script_abort
    }   
}

