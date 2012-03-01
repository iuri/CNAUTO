
ad_page_contract {
    Delete categories
} {
    category_id:notnull
    {return_url ""}
    {cancel.x:optional}
}


if {![info exists cancel.x]} {

    
    foreach element $category_id {    
#	ad_require_permission $element order_delete
	if { [catch {	cn_categories::category::delete $element } errmsg] } {
	    ad_return_complaint 1 "[_ cn-order.Delete_order_failed]: $errmsg"
	}
    }
}
ad_returnredirect $return_url


