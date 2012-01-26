ad_page_contract {
    
    Import main page

} {
    {orderby "code,asc"}
    page:optional
    {keyword ""}
} -properties {
    context:onevalue
    title:onevalue
}

set title "[_ cnauto-import.Import]"
set context [list $title]

set return_url [ad_conn url]

set actions {
    "#cnauto-import.Add_order#" "order-ae?return_url=/cnauto-order" "#cnauto-import.Add_a_new_order#"
    "#cnauto-import.Admin#" "admin/index?return_url=/cnauto-order" "#cnauto-import.Admin#"
}

set bulk_actions [list]


template::list::create \
    -name orders \
    -multirow orders \
    -key order_id \
    -actions $actions \
    -row_pretty_plural "orders" \
    -bulk_actions $bulk_actions \
    -elements {
	code {
	    label "[_ cnauto-import.Code]"
	    display_template {
		<a href="@orders.order_url@">@orders.code;noquote@
	    }
	}
	provider {
	    label "[_ cnauto-import.Provider]"
	    display_template {
		<a href="@orders.provider_url@">@orders.provider;noquote@</a>
	    }
	}
	incoterm {
	    label "[_ cnauto-import.Incoterm]"
	    display_template {
		@orders.incoterm;noquote@</a>
	    }	    
	}
	incoterm_value {
	    label "[_ cnauto-import.Incoterm_value]"
	    display_template {
		@orders.incoterm_value;noquote@</a>
	    }	    
	}
	creation_date {
	    label ""
	    display_template {
		@orders.creation_date;noquote@
	    }
	}
    } -orderby {
	code {
	    label "[_ cnauto-import.Code]"
	    orderby "lower(co.code)"
	}
    } 


set package_id [ad_conn package_id]

set workflow_id [db_string select_workflow_id {
    SELECT workflow_id FROM cn_workflows WHERE package_id = :package_id
} -default null]


db_multirow -extend {provider_url order_url} orders select_orders {} {
    
    set order_url [export_vars -base "order-one" {order_id workflow_id return_url}]

    set node_id [db_string select_node_id {
	SELECT node_id 
	FROM site_nodes sn, apm_packages ap 
	WHERE ap.package_id = sn.object_id 
	AND package_key = 'cnauto-resources'
    }]
    
    set resources_url [site_node::get_url -node_id $node_id]
    
    ns_log Notice "TEST $order_id | "
    set provider_url [export_vars -base "${resources_url}persons/person-one" {person_id return_url}]

}


ad_form -name search -form {
    {keyword:text(text)
	{label "[_ cnauto-assurance.Search]"}
    }    
} 