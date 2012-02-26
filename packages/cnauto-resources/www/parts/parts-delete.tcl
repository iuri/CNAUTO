
ad_page_contract {
    Delete parts
} {
    part_id:notnull
    {return_url ""}
    {cancel.x:optional}
}


if {![info exists cancel.x]} {

    
    foreach element $part_id {    
#	ad_require_permission $element part_delete
	if { [catch {	cn_resources::part::delete $element } errmsg] } {
	    ad_return_complaint 1 "[_ cnauto-resources.Delete_part_failed]: $errmsg"
	}
    }
}
ad_returnredirect $return_url


