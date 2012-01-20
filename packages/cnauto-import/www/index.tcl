ad_page_contract {
    
    Import main page

} {
    {orderby "provider,asc"}
    page:optional
    {keyword ""}
} -properties {
    context:onevalue
    title:onevalue
}

set title "[_ cnauto-import.Import]"
set context [list $title]

set return_url [ad_return_url]
set assurance_ae_url [export_vars -base "order-ae" {return_url}] 



set actions {
    "#cnauto-import.Add_order#" "order-ae?return_url=/cnauto-order" "#cnauto-import.Add_a_new_order#"
}

set bulk_actions [list]


set where_clause ""

if {[exists_and_not_null keyword]} {
    set where_clause "AND (cio.n = :keyword OR ca.assurance_number = :keyword)"
}



template::list::create \
    -name orders \
    -multirow orders \
    -key order_id \
    -actions $actions \
    -row_pretty_plural "orders" \
    -bulk_actions $bulk_actions \
    -page_flush_p t \
    -page_size 50 \
    -page_query_name orders_pagination \
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
	assignee {
	    label "[_ cnauto-import.Assignee]"
	    display_template {
		@orders.assignee;noquote@</a>
	    }
	}
	department {
	    label "[_ cnauto-import.Department]"
	    display_template {
		@orders.department;noquote@</a>
	    }
	}
	estimated_days {
	    label "[_ cnauto-import.Estimated_days]"
	    display_template {
		@orders.incoterm;noquote@</a>
	    }
	} 
	estimated_date {
	    label "[_ cnauto-import.Estimated_date]"
	    display_template {
		@orders.estimated_date;noquote@</a>
	    }
	}  
	executed_date {
	    label "[_ cnauto-import.Executed_date]"
	    display_template {
		@orders.executed_date;noquote@</a>
	    }
	} 
	incoterm_value {
	    label "[_ cnauto-import.Incoterm_value]"
	    display_template {
		@orders.incoterm_value;noquote@</a>
	    }
	
	}
   } -orderby {
	provider {
	    label "[_ cnauto-import.Provider]"
	    orderby "lower(cp.provider)"
	}
    } 


db_multirow -extend {assurance_url vehicle_url person_url} assurances select_assurances {
   
} {

    set assurance_url [export_vars -base assurance-one {return_url assurance_id}]
    set vehicle_url [export_vars -base vehicle-one {return_url vehicle_id}]
    set person_url [export_vars -base person-one {return_url person_id}]
}


ad_form -name search -form {
    {keyword:text(text)
	{label "[_ cnauto-assurance.Search]"}
    }    
} 