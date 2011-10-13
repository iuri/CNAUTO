ad_library {

    News Aggregator

    @creation-date 2010-03-09
    @author Alessandro Landim <alessandro.landim@gmail.com>

}

namespace eval newsletters {}
namespace eval newsletters::fields {}
namespace eval newsletters::data {}
namespace eval newsletters::email {}
namespace eval newsletters::items {}


ad_proc -public newsletters::import_csv {
    {-newsletter_id:required}
    {-tmp_file:required}
    {-update_p "0"}
} {
    Import CSV
} {

    if {$update_p} {
	newsletters::email::delete -newsletter_id $newsletter_id
	newsletters::data::delete -newsletter_id $newsletter_id
    }

    set num 0
    oacs_util::csv_foreach -file $tmp_file -array_name row {

		if {$num == 0} {
			set fields [array names row]
	
			# clean fields
			set fields_names ""
			set available_fields ""
			set fields_to_delete ""
		        foreach field_name $fields {
				if {$field_name != "email" && $field_name != "name"} {
					lappend fields_names $field_name
				}
			}
			set fields $fields_names
	
			foreach field_name $fields {
				set field_id($field_name) [newsletters::fields::new -name $field_name -newsletter_id $newsletter_id]
				lappend available_fields $field_id($field_name)
			}
			
			set available_fields_list_sql [join $available_fields ","]
			if {$available_fields_list_sql != ""} {
	 			set fields_to_delete [db_list get_list "select field_id from newsletters_fields where newsletter_id = :newsletter_id and field_id not in ($available_fields_list_sql)"]
			}
			
			foreach field_to_delete $fields_to_delete {
				newsletters::fields::delete -field_id $field_to_delete
			}
		}


		if {![exists_and_not_null row(name)]} {
			set row(name) $row(email)
		}

		newsletters::email::new -name $row(name) -email $row(email) -newsletter_id $newsletter_id
	    foreach field_name $fields {
			newsletters::data::new -field_id $field_id($field_name) -data $row($field_name) -email $row(email)
		}
		incr num
   }


   return $newsletter_id

}	




ad_proc -public newsletters::new {
	{-newsletter_id "null"}
	{-name:required}
	{-description:required}
	{-tmp_file:required}
} {
    create new newsletter
} {
	set package_id 	  [ad_conn package_id]
	set creation_user [ad_conn user_id]
	set creation_ip 	  [ad_conn peeraddr]
		
	set newsletter_id [db_string create_newsletter {
			select newsletters__new (
	            :newsletter_id,		-- newsletter_id
			    :name,				-- name
			    :description,		-- description
			    :package_id,		-- package_id
			    now(), 				-- creation_date
			    :creation_user,		-- creation_user
			    :creation_ip, 		-- creation_ip
			    :package_id			-- context_id
			)
	}]

	newsletters::import_csv -newsletter_id $newsletter_id -tmp_file $tmp_file
	return $newsletter_id
}



ad_proc -public newsletters::edit {
	{-newsletter_id:required}
	{-name:required}
	{-description:required}
} {
    Edit newsletter
} {
		
		return [db_string edit_newsletter {
			select newsletters__edit (
				:newsletter_id,			-- data_id
				:name,					-- name
				:description			-- description
			)
		}]
}

ad_proc -public newsletters::get_name {
	{-newsletter_id:required}
} {
    Get name of newsletter
} {
		
		return [db_string get_name { select name from newsletters where newsletter_id = :newsletter_id}]
}



ad_proc -public newsletters::email::delete {
	{-newsletter_id:required}
} {
	db_dml delete_field {
			delete from newsletters_emails where newsletter_id = :newsletter_id
	}
}


ad_proc -public newsletters::delete {
	{-newsletter_id:required}
} {
     Delete News Letter
} {
	set list_of_fields [db_list get_fields {select field_id from newsletters_fields where newsletter_id = :newsletter_id}]
	foreach field_id $list_of_fields {
		newsletters::fields::delete -field_id $field_id
	}
	set list_of_items [db_list get_fields {select newsletter_item_id from newsletters_items where newsletter_id = :newsletter_id}]
	foreach item_id $list_of_items {
		newsletters::items::delete -item_id $item_id
	}

	return [db_string delete_newsletters {
			select newsletters__del(:newsletter_id)
	}]
}

ad_proc -public newsletters::data::delete {
	{-newsletter_id:required}
} {
     Delete Data NewsLetter
} {
	return [db_string delete_data_newsletters {
			select newsletters_data__del(:newsletter_id)
	}]
}


ad_proc -public newsletters::fields::delete {
	{-field_id:required}
} {
    delete field 
} {
		db_exec_plsql delete_field {
			select newsletters_fields__del(:field_id)
		}
}

ad_proc -public newsletters::items::delete {
	{-item_id:required}
} {
    delete field 
} {

    	ams::object_delete -object_id $item_id
		db_exec_plsql delete_item {
			select newsletters_items__del(:item_id)
		}
}


ad_proc -public newsletters::fields::update_name {
	{-field_id:required}
	{-name:required}
} {
    update field pretty_name
} {
		db_dml update_pretty_name {
			update newsletters_fields set name = :name where field_id = :field_id
		}
}

ad_proc -public newsletters::fields::get_values {
	{-field_id:required}
} {
    get values
} {
	return [db_list get_values {select distinct data from newsletters_data where field_id = :field_id}]
}

ad_proc -public newsletters::fields::newsletter_id {
	{-field_id:required}
} {
    get Newsletter ID
} {
	return [db_string get_newsletter_id {select newsletter_id from newsletters_fields where field_id = :field_id} -default ""]
}


ad_proc -public newsletters::fields::new {
    {-newsletter_id:required}
    {-name ""}
} {
    create new field
} {

	set package_id 	  [ad_conn package_id]
	set creation_user [ad_conn user_id]
	set creation_ip   [ad_conn peeraddr]
	
	set exists [db_string test {select field_id from newsletters_fields where newsletter_id = :newsletter_id and name = :name} -default ""]
	if {$exists != ""} {
		return $exists
	} 
	

	set field_id [db_string create_field {
		select newsletters_fields__new (
		            null, 			    -- field_id
			    :newsletter_id,		    -- newsletter_id
			    :name, 	    		    -- pretty_name
			    :package_id,    		    -- package_id
			    now(), 			    -- creation_date
			    :creation_user,     	    -- creation_user
			    :creation_ip, 		    -- creation_ip
			    :newsletter_id		    -- context_id
		)
	}]

	return $field_id
}

ad_proc -public newsletters::fields::get_list {
    {-newsletter_id:required}
} {
    Get a list of fields from newsletter_id.
} {
	set result ""
	db_multirow get_fields select_fields {
			select name, field_id
			from newsletters_fields
			where newsletter_id = :newsletter_id
			and ignore = 'f'
			order by sort_order
	} {
			lappend result [list $field_id $name]

	}
	return $result
}
ad_proc -public newsletters::fields::edit {
    {-field_id:required}
	{-name:required}
	{-sort_order:required}
	{-ignore:required}
} {
	return [db_string update_field {
		select newsletters_fields__edit (
		        :field_id, 			-- field_id
		        :name, 			    -- name
		        :sort_order, 		-- sort_order
		        :ignore 			-- ignore
		)
	}]
}	


ad_proc -public newsletters::data::new {
    {-field_id:required}
    {-email:required}
    {-data ""}
} {
    create new data
} {
	set exists [db_string test {select 1 from newsletters_data where email = :email and field_id = :field_id} -default 0]
	if {$exists} {
		return
	} 
	

	db_exec_plsql create_data {
		select newsletters_data__new (
                            :field_id,		-- field_id
			    :email,  		-- email
			    :data 		-- data
		)
	}
}


ad_proc -public newsletters::email::new {
    {-newsletter_id:required}
    {-name:required}
    {-email:required}
} {
    create new data
} {
	#test if exists 
	set exists [db_string test {select 1 from newsletters_emails where email = :email and newsletter_id = :newsletter_id} -default 0]
	if {$exists} {
		return
	} 
	
	db_exec_plsql create_data {
		select newsletters_email__new (
                            :newsletter_id,		-- field_id
			    :name, 			-- name
			    :email  			-- email
		)
	}
}


ad_proc -public newsletters::email::get_filtred {
	{-fields_data_list:required}
	{-newsletter_id:required}
} {
	set email_where_clause ""
	foreach field $fields_data_list {
		util_unlist $field field_id data
		if {[string first  "_all" $data] < 0} {
			append  email_where_clause " AND 1 = (select 1 from newsletters_data nd1 where  nd1.email = ne.email and nd1.field_id = $field_id "
			set i 0
			foreach data_one $data {
				if {$i == 0} {
					append email_where_clause " and nd1.data in ('1' "
				}
 				append email_where_clause ", '$data_one'"
				incr i
			}
			append email_where_clause "))"
		}
	}
	
	return [db_list get_emails {}]
}

ad_proc -public newsletters::email::not_valid {
	{-newsletter_id:required}
	{-email:required}
} {
	db_dml update_email {update newsletters_emails set valid = 'f' where email = :email and newsletter_id = :newsletter_id}
}



ad_proc -public newsletters::items::save {
	{-newsletter_id:required}
	{-title:required}
	{-content:required}
	{-item_number:required}
	{-email_list:required}
} {
    Save newsletter item
} {
	set package_id 	  [ad_conn package_id]
	set creation_user [ad_conn user_id]
	set creation_ip 	  [ad_conn peeraddr]
		
	set newsletter_item_id [db_string create_newsletter {
			select newsletters_items__new (
                 null,			-- newsletter_item_id
                :newsletter_id,	-- newsletter_id
			    :title,			-- title
			    :content,			-- content
			    :item_number,		-- item_number
			    :email_list,		-- email_list
			    :package_id,		-- package_id
			    now(), 			-- creation_date
			    :creation_user,		-- creation_user
			    :creation_ip, 		-- creation_ip
			    :newsletter_id		-- context_id
			)
	}]
	return $newsletter_item_id
}

ad_proc -public newsletters::items::update_content {
	{-newsletter_item_id:required}
	{-content:required}
} {
	db_dml update_content {update newsletters_items set content = :content where newsletter_item_id = :newsletter_item_id}
}	
