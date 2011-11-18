ad_page_contract {
} {
    return_url
    spreadsheet_id
    option
}

if {$option eq 1} {
    foreach id $spreadsheet_id {
	cn_spreadsheet::delete -spreadsheet_id $id
    }
}

ad_returnredirect $return_url
    
