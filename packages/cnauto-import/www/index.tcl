ad_page_contract {
    
    Import main page

} {
    {orderby "order_id,asc"}
    page:optional
    {keyword ""}
} -properties {
    context:onevalue
    title:onevalue
}

auth::require_login

set title "[_ cnauto-import.Import]"
set context [list $title]

set return_url [ad_conn url]

set admin_p [permission::permission_p -object_id [ad_conn package_id] -privilege admin]

set actions [list]
set bulk_actions [list]
    
if { $admin_p } {
    
    set actions {
	"#cnauto-import.Add_order#" "order-ae?step=1&return_url=/cnauto-order" "#cnauto-import.Add_a_new_order#"
	"#cnauto-import.Admin#" "admin/index?return_url=/cnauto-order" "#cnauto-import.Admin#"
    }
        
    set bulk_actions {"#cnauto-import.Delete#" "order-bulk-delete" "#cnauto-import.Delete_selected_orders#"}
} 



set where_clause ""
if {$keyword ne ""} {
    set where_clause "WHERE cio.cnimp_number = :keyword"
}


template::list::create \
    -name orders \
    -multirow orders \
    -key order_id \
    -actions $actions \
    -row_pretty_plural "orders" \
    -bulk_actions $bulk_actions \
    -bulk_action_export_vars { return_url } \
    -elements {
	di_status {
	    label "[_ cnauto-import.Status]"
	    display_template {
		<div style="width:15px; height:15px; background-color: @orders.di_status;noquote@;">&nbsp;</div>
	    }
	}
	cnimp_number {
	    label "[_ cnauto-import.CNIMP]"
	    display_template {
		<if @orders.parent_id@ ne "">&nbsp;&nbsp;&nbsp;&nbsp;</if>
		<a href="@orders.cnimp_url@">@orders.cnimp_number;noquote@
	    }
	}
	provider_pretty {
	    label "[_ cnauto-import.Provider]"
	    display_template {
		<a href="@orders.provider_url@">@orders.provider_pretty;noquote@
	    }
	}
	cnimp_date {
	 label "[_ cnauto-import.CNIMP_date]"
	    
	}   
    } -orderby {
	order_id {
	    label ""
	    orderby "cio.order_id"
	}
	cnimp_number {
	    label "[_ cnauto-import.CNIMP]"
	    orderby "cio.cnimp_number"
	}
	provider_pretty {
	    label "[_ cnauto-import.Provider]"
	    orderby "cp.pretty_name"
	}
	cnimp_date {
	    label "[_ cnauto-import.CNIMP_date]"
	    orderby "cio.cnimp_date"
	}
    } 




db_multirow -extend {cnimp_url provider_url} orders select_orders {} {
    
    set cnimp_url [export_vars -base "order-one" {order_id return_url}]
    set provider_url [export_vars -base "/cnauto/cnauto-resources/persons/person-one" {person_id return_url}]



    if {$cnimp_date ne ""} {
	set date [lindex $cnimp_date 0]
	set date [split $date "-"]
	set cnimp_date "[lindex $date 2]/[lindex $date 1]/[lindex $date 0]"
    }
    
}

