ad_page_contract {
    Add item 
    
    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    @creation-date 2011-10-31
} {
    {spreadsheet_id}
    {element ""}
    {return_url ""}
}


set title "#cn-spreadhseet.Add_item#"
set context "{$title}"
set focus ""


ad_form -name item-ae -action item-ae -cancel_url $return_url -form {
    {inform:text(inform)
	{label "<span style=\"font-size:14px;\"><b>Add Item</b></span>"}
    }
} -edit_data {

    db_foreach select_fields { 
	SELECT field_id FROM cn_spreadsheet_data WHERE element = :element
    } {
	set value ":${field_id}"
	db_dml update_data "
	    UPDATE cn_spreadsheet_data SET data = $value WHERE field_id = :field_id AND element = :element
	"
    }
} -new_data {
    
    # Insert element
    #definir leement chave
    set element 
    db_foreach select_fields { 
	SELECT field_id FROM cn_spreadsheet_fields WHERE spreadsheet_id = :spreadsheet_id
    } {
	set value ":${field_id}"
	db_exec_plpsql insert_data {
	    SELECT cn_spreadsheet_data__new (
					     :field_id,
					     :element,
					     :data
					     );
	}
	
    } -after_submit {}

if {$element == ""} {
    set extra_select ""
    set extra_from ""
    set extra_where ""
} {
    set extra_select ", sd.data"
    set extra_from ", cn_spreadsheet_data sd"
    set extra_where " AND sf.field_id = sd.field_id AND sd.element = :element"
}

db_foreach select_field_id " 
    SELECT sf.field_id, sf.required_p $extra_select 
    FROM cn_spreadsheet_fields sf $extra_from
    WHERE sf.spreadsheet_id = :spreadsheet_id
    $extra_where
" {
    set name [encoding convertto iso8859-1 [db_string select_name {
	SELECT name FROM cn_spreadsheet_fields WHERE field_id = :field_id

    } -default ""]]
    set name [lang::message::lookup "" cn-spreadsheet.${field_id} "${name}"]

    if {[info exists data]} {
    
	if {[exists_and_not_null required_p]} {
	
	    ad_form -extend -name item-ae -form {
		{$field_id:text(text)
		    {label $name}
		    {value $data}
		}	
	    }
	} else {
	    ad_form -extend -name item-ae -form {
		{$field_id:text(text),optional
		    {label $name}
		    {value $data}
		}
	    }
	}
    } else {
	if {[exists_and_not_null required_p]} {
	    
	    ad_form -extend -name item-ae -form {
		{$field_id:text(text)
		    {label $name}
		}	
	    }
	} else {
	    ad_form -extend -name item-ae -form {
		{$field_id:text(text),optional
		    {label $name}
		}
	    }
	}
	
	
    }
}