ad_page_contract {
  List data aggregator for this package_id 

  @author Alessandro Landim

} {
	{newsletter_id}
} 

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

permission::require_permission -party_id $user_id -object_id $newsletter_id -privilege admin
set action_list ""
set csv "email"



db_multirow fields_list select_fields {
       select name,field_id
        from newsletters_fields
	    where newsletter_id = :newsletter_id
		order by field_id
} {
	lappend fields $field_id
	append csv ",$name"
}

set latest_email ""
db_multirow newsletter_list select_emails {} {
	if {$latest_email == $email} {
		append csv ",$data"
	} else {
		append csv "\n"
		append csv "$email,$data"
	}
	set latest_email $email
}

set filename_base [ns_mktemp "/tmp/csvXXXXXX"]
set fd [open $filename_base w]
set csv [encoding convertfrom utf-8 $csv]
puts $fd $csv
close $fd
	
ns_set update [ns_conn outputheaders] Content-Disposition "attachment; filename=\"emais-export.csv\""
ns_returnfile 200 text/csv $filename_base
file delete $filename_base
