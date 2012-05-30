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
	"#cnauto-import.Add_order#" "order-ae?step=1&return_url=/cnauto/Import" "#cnauto-import.Add_a_new_order#"
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
    -row_pretty_plural "orders" \
    -actions $actions \
    -bulk_actions $bulk_actions \
    -bulk_action_export_vars { return_url } \
    -elements {
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
		<a href="@orders.provider_url@">@orders.provider_pretty;noquote@</a>
	    }
	}
	fabricant_pretty {
	    label "[_ cnauto-import.Fabricant]"
	    display_template {
		<a href="@orders.fabricant_url@">@orders.fabricant_pretty;noquote@</a>
	    }
	}
	cnimp_date {
	    label "[_ cnauto-import.CNIMP_date]"
	    
	}
	transport_type {
	    label "[_ cnauto-import.Modal]"
	    display_template {
		<if @orders.transport_type@ eq 1>[_ cnauto-import.Seaport]</if>	
		<if @orders.transport_type@ eq 2>[_ cnauto-import.Airport]</if>
	    }
	}
	li {
	    label "[_ cnauto-import.LI]"
	    
	    display_template {
		<if @orders.li_need_p@ eq t><input type="checkbox" disabled="disabled" name="li" value="@orders.li_need_p@" checked></if>
		<else><input type="checkbox" disabled="disabled" name="li" value="@orders.li_need_p@"></else>
	    }
	}	    
	order_cost {
	    label "[_ cnauto-import.Total_value]"
	}
	comments {
	    label "[_ cnauto-import.Notes]"
	}
	di_status {
	    label "[_ cnauto-import.Status]"
	    display_template {
		<div style="width:15px; height:15px; background-color: @orders.di_status;noquote@;">&nbsp;</div>
	    }
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
	fabricant_pretty {
	    label "[_ cnauto-import.Fabricant]"
	    orderby "cp1.pretty_name"
	}
	cnimp_date {
	    label "[_ cnauto-import.CNIMP_date]"
	    orderby "cio.cnimp_date"
	}
    } 




db_multirow -extend {comments cnimp_url fabricant_url provider_url} orders select_orders {} {
    
    set cnimp_url [export_vars -base "order-one" {order_id return_url}]
    set provider_url [export_vars -base "/cnauto/cnauto-resources/persons/person-one" {person_id return_url}]

    set fabricant_url [export_vars -base "/cnauto/cnauto-resources/persons/person-one" {{person_id $fabricant_id} return_url}]


    if {$cnimp_date ne ""} {
	set date [lindex $cnimp_date 0]
	set date [split $date "-"]
	set cnimp_date "[lindex $date 2]/[lindex $date 1]/[lindex $date 0]"
    }
    

    set comments [db_string select_comment {} -default ""]
}

    