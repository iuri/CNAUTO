ad_page_contract {
    Delete spreadsheet

    @author Iuri Sampaio
    @creation-date 2011-10-27
} {
    spreadsheet_id:multiple
    {return_url ""}
}


#permission::require_permission -party_id [ad_conn user_id] -object_id $spreadsheet_id -privilege admin


set spreadsheet_ids $spreadsheet_id

foreach element $spreadsheet_ids {
    lappend spreadsheet_ids "'[DoubleApos $element]'"
}

set spreadsheet_ids [join $spreadsheet_ids ","]

template::list::create \
    -name spreadsheets \
    -multirow spreadsheets \
    -key spreadsheet_id \
    -elements {
	name {
	    label "#cn-spreadsheet.Name#"
	    display_template { @spreadsheets.name@}
	}
	description {
	    label "#cn-spreadsheet.Description#"
	    display_template { @spreadsheets.description@}
	}   
    }


db_multirow -extend {} spreadsheets select_spreadsheets "
      SELECT name,description FROM cn_spreadsheets WHERE spreadsheet_id IN ($spreadsheet_ids)
    "



ad_form -export {return_url spreadsheet_id} -action spreadsheet-del-2 -name spreadsheet -form {
    {option:text(radio) 
	{label "#cn-spreadsheet.Choose_Option_to_delete#"}
	{options {{"#cn-spreadsheet.Yes#" 1} {"#scn-preadsheet.No#" 0}}}  
    }
    
} 




	
