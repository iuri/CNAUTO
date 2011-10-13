ad_page_contract {
  List data aggregator for this package_id 

  @author Alessandro Landim

} 

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

permission::require_permission -party_id [ad_conn user_id] -object_id [ad_conn package_id] -privilege read
set admin_p [permission::permission_p -party_id [ad_conn user_id] -object_id [ad_conn package_id] -privilege admin]
set site_wide [acs_user::site_wide_admin_p]
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

if {[llength $newsletters_ids] == 1} {
	ad_returnredirect newsletter-items?newsletter_id=$newsletters_ids
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
    atd {
        label ""
        display_template {
	   		@newsletter_list.qtd@ emails cadastrados 
	    }
    }
	actions {
        label ""
        display_template {
			<div class="options_list">
			<ul>
			<if $site_wide>
	         <li><a class="button" href="newsletter-del?newsletter_id=@newsletter_list.newsletter_id@">
				#newsletter.Delete#
			</a></li> 
 	        <li><a class="button" href="newsletter-new?newsletter_id=@newsletter_list.newsletter_id@">
				#newsletter.Edit#
			</a></li>

			</if>
			</ul>
			</div>

        }
    }
}

db_multirow -extend {qtd} newsletter_list select_newsletter {
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
} {
 set qtd [db_string select_emails	"select count(*) as qtd
			from newsletters_emails ne 
			where ne.valid = 't'
			and ne.newsletter_id = :newsletter_id" -default 0]

}
