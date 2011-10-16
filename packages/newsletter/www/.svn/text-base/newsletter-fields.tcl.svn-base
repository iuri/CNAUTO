ad_page_contract {
  List data aggregator for this package_id 

  @author Alessandro Landim

} {
	newsletter_id
}

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

permission::require_permission -party_id [ad_conn user_id] -object_id [ad_conn package_id] -privilege read
set admin_p [permission::permission_p -party_id [ad_conn user_id] -object_id [ad_conn package_id] -privilege admin]
set action_list ""



template::head::add_css -href "/resources/newsletter/newsletter.css"

template::list::create -name fields_list -multirow fields_list -key field_id -pass_properties {
} -elements {
    name {
        label ""
        display_template {
	        <a href="field-edit?field_id=@fields_list.field_id@">
				@fields_list.name@
			</a>
        }
    }
	ignore {
		 display_template {
			<if @fields_list.ignore@ eq "f">
					1
			</if>
			<else>
				 	2
			</else>
        }
	
	}
}

db_multirow fields_list select_newsletter {
       select field_id,
			  name,
			  sort_order,
			  ignore
       from newsletters_fields
	   where newsletter_id = :newsletter_id
}
