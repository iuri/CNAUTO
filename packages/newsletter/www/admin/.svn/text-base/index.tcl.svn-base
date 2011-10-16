ad_page_contract {
  List data aggregator for this package_id 

  @author Alessandro Landim

} 

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

permission::require_permission -party_id [ad_conn user_id] -object_id [ad_conn package_id] -privilege read
set admin_p [permission::permission_p -party_id [ad_conn user_id] -object_id [ad_conn package_id] -privilege admin]
set action_list ""


set newsletters_ids [db_list get {select newsletter_id
           from newsletters nl,
		acs_objects ao
	    where nl.newsletter_id = ao.object_id
		and   ao.package_id = :package_id
}]

if {$admin_p eq 1} {
	set action_list {"#newsletter.New#" newsletter-new "#newsletter.New#"}
}



template::head::add_css -href "/resources/newsletter/newsletter.css"

template::list::create -name newsletter_list -multirow newsletter_list -key newsletter_id -actions $action_list -pass_properties {
} -elements {
    name {
        label ""
        display_template {
	        <a href="newsletter-items?newsletter_id=@newsletter_list.newsletter_id@">
				@newsletter_list.name@
			</a>
        }
    }
	actions {
        label ""
        display_template {
			<div class="options_list">
			<ul>
			<if @newsletter_list.admin_p@>
	        <!-- <li><a class="button" href="newsletter-del?newsletter_id=@newsletter_list.newsletter_id@">
				#newsletter.Delete#
			</a></li> -->
 	        <li><a class="button" href="newsletter-new?newsletter_id=@newsletter_list.newsletter_id@">
				#newsletter.Edit#
			</a></li>
  	        <li><a class="button" href="newsletter-fields?newsletter_id=@newsletter_list.newsletter_id@">
				#newsletter.Fields#
			</a></li> 

	        <li><a class="button" href="newsletter-emails-export?newsletter_id=@newsletter_list.newsletter_id@">
				#newsletter.Export_emails#
			</a></li>
			</if>
			</ul>
			</div>

        }
    }
}

db_multirow newsletter_list select_newsletter {
       select newsletter_id,
		   name,
		   description,
           acs_permission__permission_p(newsletter_id, :user_id, 'admin') as admin_p
           from newsletters nl,
		acs_objects ao
	    where package_id = :package_id
		and   nl.newsletter_id = ao.object_id
		and   ao.package_id = :package_id	
        	and 't' = acs_permission__permission_p(newsletter_id, :user_id, 'read')
}
