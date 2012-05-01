ad_page_contract {
    Categories main page
  
} { 
    {orderby "renavam_id,asc"}
    {keyword:optional}
    {renavam_id:optional}
    page:optional
} -properties {
    context:onevalue
    title:onevalue
}


set title "[_ cnauto-core.Renavam]"
set context [list $title]

set return_url [ad_conn url]

set renavam_add [export_vars -base "renavam-ae" {return_url}] 

set actions [list \
		 "[_ cnauto-resources.Add_renavam]" "$renavam_add" "[_ cnauto-resources.Add_renavam]" \
		 "[_ cnauto-resources.Import_renavam]" "renavam-import" "" \
		]

set bulk_actions {"#cnauto-resources.Delete#" "renavam-bulk-delete" "#cnauto-resource.Delete_selected_ren#"}



template::list::create \
    -name renavam \
    -multirow renavam \
    -key renavam_id \
    -actions $actions \
    -bulk_actions $bulk_actions \
    -bulk_action_export_vars { return_url } \
    -row_pretty_plural "renavam" \
    -page_size 10 \
    -page_flush_p t \
    -page_query_name renavam_pagination \
    -elements {
	fabricant {
	    label "[_ cnauto-resources.Fabtricant]"
	}
	lcvm {
	    label "[_ cnauto-resources.LCVM]"
	}
	model {
	    label "[_ cnauto-resources.Model]"
	}
	version {
	    label "[_ cnauto-resources.Version]"
	}
	code {
	    label "[_ cnauto-resources.Code]"
	}
	action {
	    label ""
	    display_template {
		<a href="@renavam.renavam_url@"><img src="/shared/images/Edit16.gif" border="0" width="16" height="16"></a>
	    }
	}
    }

 
db_multirow -extend {renavam_url} renavam select_renavam {} {
    set renavam_url [export_vars -base renavam-ae {renavam_id return_url}]

}

