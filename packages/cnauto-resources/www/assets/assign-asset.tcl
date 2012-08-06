ad_page_contract {} {
    {asset_id}
    {group_id 752}
    {return_url ""}
}


set actions {}
set bulk_actions {"#cnauto-resources.Assign_asset#" "assign-asset-2" "#cnauto-resources,Assig_n_asset_to_a_user#"}


set user_id [ad_conn user_id]

db_1row pretty_roles {}

template::list::create \
    -name "members" \
    -multirow "members" \
    -row_pretty_plural "members" \
    -page_size 50 \
    -page_flush_p t \
    -page_query_name members_pagination \
    -actions $actions \
    -key user_id \
    -bulk_actions $bulk_actions \
    -bulk_action_method get \
    -bulk_action_export_vars {asset_id return_url} \
    -elements {
        name {
            label "[_ acs-subsite.Name]"
            link_url_eval {[acs_community_member_url -user_id $user_id]}
        }
        email {
           label "[_ acs-subsite.Email]"
	    display_template {
		@members.user_email;noquote@
	    }
        }
        rel_role {
            label "[_ acs-subsite.Role]"
            display_template {
                @members.rel_role_pretty@
            }
        }
    }

# Pull out all the relations of the specified type

set show_partial_email_p [expr {$user_id == 0}]

db_multirow -extend { 
    email_url
    rel_role_pretty
    user_email
} -unclobber members members_select {} {
    if { $member_admin_p > 0 } {
        set rel_role_pretty [lang::util::localize $admin_role_pretty]
    } else {
        if { $other_role_pretty ne "" } {
            set rel_role_pretty [lang::util::localize $other_role_pretty]
        } else {
            set rel_role_pretty [lang::util::localize $member_role_pretty]
        }
    }
    set member_state_pretty [group::get_member_state_pretty -member_state $member_state]
    set user_email [email_image::get_user_email -user_id $user_id]
    
    if { [ad_conn user_id] == 0 } {
        set email [string replace $email \
                       [expr {[string first "@" $email]+3}] end "..."]
    } else {
        set email_url "mailto:$email"
    }
}

