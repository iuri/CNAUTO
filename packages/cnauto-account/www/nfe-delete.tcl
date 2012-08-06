
ad_page_contract {
    Delete nfes
} {
    nfe_id:notnull
    {return_url ""}
    {cancel.x:optional}
}


if {![info exists cancel.x]} {

    
    foreach element $nfe_id {    
#	ad_require_permission $element order_delete
	if { [catch {	cn_account::nfe::delete -nfe_id $element } errmsg] } {
	    ad_return_complaint 1 "[_ cn-account.Delete_order_failed]: $errmsg"
	}
    }
}
ad_returnredirect $return_url


