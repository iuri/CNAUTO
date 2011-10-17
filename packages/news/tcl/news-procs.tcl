# /packages/news/tcl/news-procs.tcl
ad_library {
    Utility functions for News Application

    @author stefan@arsdigita.com
    @creation-date 12-14-00
    @cvs-id $Id: news-procs.tcl,v 1.3 2006/11/08 18:56:41 alessandrol Exp $
}



# News specific db-API wrapper functions and interpreters
ad_proc news_get_package_id {
    -community_id
} {
   Get the news package in the selected community 

    @param community_id
} {

    if {[info exist community_id] == 0} {
        set community_id [dotlrn_community::get_community_id]        
    }

    db_1row get_news_package_id {}

    return $package_id
}



ad_proc news_items_archive { id_list when } {

    immediately gives all news items in list id_list
    a status of archived as of ANSI date in when, i.e. when must be like 2000-10-11.

} {

    foreach id $id_list {
	db_exec_plsql news_item_archive {
	    begin
	    news.archive(
	        item_id => :id,
	        archive_date => :when);
	    end;
	}
    }

}


ad_proc news_items_make_permanent { id_list } {

    immediately gives all news items in list id_list
    a status of permanently published

} {

    foreach id  $id_list {
	db_exec_plsql news_item_make_permanent {
	    begin
	        news.make_permanent(:id);
	    end;
	}
    }

}


ad_proc news_items_delete { id_list } {

    deletes all news items with news_id in id_list

} { 

    foreach id $id_list {
	
	news_delete_replicated_items $id

	db_exec_plsql news_item_delete {
	    begin
	        news.del(:id);
	    end;
	}

    }

}


ad_proc news_util_get_url {
    package_id
} {
    @author Robert Locke
} {

    set url_stub ""

    db_0or1row get_url_stub "
        select site_node__url(node_id) as url_stub
        from site_nodes
        where object_id=:package_id
    "

    return $url_stub

}

ad_proc test_file_type {
    imgsrc
} {
    Used in form validation to check that the uploaded file type really is
    what it's meant to be (invokes 'identify' on the file).

    @author Tom Ayles (tom@beatniq.net)
} {
   ns_log Notice "imgsrc: $imgsrc"
    set mime_types [split \
                        [parameter::get -parameter ImageFormat] \
                        {,}]
    if {[catch \
             {array set img_props [ImageMagick::identify $imgsrc]} \
             errmsg]} {
        return 0
    }
    set mime_type "image/[string tolower $img_props(format)]"
    if {[lsearch $mime_types $mime_type] < 0} {
        return 0
    }
    return 1
}

ad_proc news_revision_set_image_id {
    revision_id
    image_id
} {
    Associates an image with a revision of a news item.
    
    @author simon@simonbuckle.com
} {
    set creation_user [ad_conn user_id]
    set peeraddr [ad_conn peeraddr]

    db_exec_plsql set_image_rel {}
}

ad_proc news_revision_get_image_id {
    revision_id
} {
    Returns the image id if there is one associated with this image, empty string otherwise
    
    @author simon@simonbuckle.com
} {
    return [relation::get_object_two -object_id_one $revision_id -rel_type "relationship"]
}

ad_proc news_get_image_id {
    item_id
} {
    Retrieves the image associated with the given news item.

    @author Tom Ayles (tom@beatniq.net)
} {
    return [db_string img {} -default {}]
}

ad_proc news__datasource {
    object_id
} {
    

    @author Jeff Davis (davis@xarg.net)
} {
    db_1row get {
        select
        item_id,
        package_id,
        live_revision,
        publish_title,
        publish_lead,
        html_p,
        publish_date,
        publish_body,
        creation_user,
        item_creator
        from news_items_live_or_submitted
        where item_id = :object_id
        or item_id = (select item_id from cr_revisions where revision_id = :object_id)}

    set url_stub [news_util_get_url $package_id]
    set url "[ad_url]${url_stub}item/$item_id"

    if {[empty_string_p $publish_lead]} {
        set publish_lead $publish_body
    }

    set content [template::adp_include /packages/news/www/news \
                     [list \
                          item_id $object_id \
                          publish_title $publish_title \
                          publish_title $publish_lead \
                          publish_body $publish_body \
                          publish_image {} \
                          creator_link $item_creator ]]

    return [list \
                object_id $object_id \
                title $publish_title \
                content $content \
                mime text/html \
                keywords {} \
                storage_type text \
                syndication [list link $url \
                                 description $publish_lead \
                                 author $item_creator \
                                 category News \
                                 guid "[ad_url]/o/$item_id" \
                                 pubDate $publish_date \
                                ] \
               ]
}


ad_proc news__url {
    object_id
} {
    @author Robert Locke
} {
    db_1row get {}
    return "[ad_url][news_util_get_url $package_id]item/$item_id"
}

ad_proc news_pretty_status { 
    {-publish_date:required}
    {-archive_date:required}
    {-status:required}
} {
    Given the publish status of a news items  return a localization human readable
    sentence for the status.

    @param status Publish status short name. Valid values are returned
    by the plsql function news_status.

    @author Peter Marklund
} {
    array set news_status_keys {
        unapproved news.Unapproved
        going_live_no_archive news.going_live_no_archive
        going_live_with_archive news.going_live_with_archive
        published_no_archive news.published_no_archive
        published_with_archive news.published_scheduled_for_archive
        archived news.Archived
    }

    set now_seconds [clock scan now]
    set n_days_until_archive {}

    if { ![empty_string_p $archive_date] } { 
        set archive_date_seconds [clock scan $archive_date]

        if { $archive_date_seconds > $now_seconds } {
            # Scheduled for archive
            set n_days_until_archive [expr ($archive_date_seconds - $now_seconds) / 86400]
        }
    }

    if { ![empty_string_p $publish_date] } {
        # The item has been published or is scheduled to be published

        set publish_date_seconds [clock scan $publish_date]
        if { $publish_date_seconds > $now_seconds } {
            # Will be published in the future

            set n_days_until_publish [expr ($publish_date_seconds - $now_seconds) / 86400]
        }
    }

    # Message lookup may use vars n_days_until_archive and n_days_until_publis
    return [_ $news_status_keys($status)]
}


# register news search implementation
namespace eval news::sc {}

ad_proc -private news::sc::unregister_news_fts_impl {} {
    db_transaction {
        acs_sc::impl::delete -contract_name FtsContentProvider -impl_name news
    }
}

ad_proc -private news::sc::register_news_fts_impl {} {
    set spec {
        name "news"
        aliases {
            datasource news__datasource
            url news__url
        }
        contract_name FtsContentProvider
        owner news
    }

    acs_sc::impl::new_from_spec -spec $spec
}


ad_proc -public news__last_updated {
    package_id
} {

    Return the timestamp of the most recent item in this news instance

    @author Dave Bauer (dave@thedesignexperience.org)
    @creation-date 2005-01-22

    @param package_id

    @return

    @error
} {
    return [db_string get_last_updated ""]
}

ad_proc -private news__rss_datasource {
    summary_context_id
} {
    This procedure implements the "datasource" operation of the 
    RssGenerationSubscriber service contract.  

    @author Dave Bauer (dave@thedesignexperience.org)
} {
    # TODO make limit a parameter
    set limit 15 

    set items [list]
    set counter 0
    set package_url [news_util_get_url $summary_context_id]
    db_foreach get_news_items {} {
        set entry_url [export_vars -base "[ad_url]${package_url}item" {item_id}]

        #set content_as_text [ad_html_text_convert -from $mime_type -to text/plain $content]
        # for now, support only full content in feed
   	set publish_body204 [string trimleft [util_close_html_tags $content "500" "500" "\[...\]" ""] "*"]
        set description $publish_body204

        # Always convert timestamp to GMT
        set entry_date_ansi [lc_time_tz_convert -from [lang::system::timezone] -to "Etc/GMT" -time_value $last_modified]
        set entry_timestamp "[clock format [clock scan $entry_date_ansi] -format "%a, %d %b %Y %H:%M:%S"] GMT"
	
	set image_id_size_2 [ImageMagick::util::get_image_id -item_id $item_id -name "size-2"]

        if {![empty_string_p $image_id_size_2]} {
		set description "<img src=\"[ad_url]${package_url}image/${image_id_size_2}\"><br>$description"
	}

        lappend items [list \
                           link $entry_url \
                           title $title \
                           description $description \
                           value $content \
                           timestamp $entry_timestamp]

        if { $counter == 0 } {
            set column_array(channel_lastBuildDate) $entry_timestamp
            incr counter
        }
    }

    set image [parameter::get -package_id $summary_context_id -parameter RSSImageUrl]

    if {$image !=  ""} {
		set image "[ad_url]$image"
    }

    set column_array(channel_title) [parameter::get -package_id $summary_context_id -parameter RSSTitle]
    set column_array(channel_description) "[_ news.News]"
    set column_array(items) $items
    set column_array(channel_language) ""
    set column_array(channel_copyright) ""
    set column_array(channel_managingEditor) ""
    set column_array(channel_webMaster) ""
    set column_array(channel_rating) ""
    set column_array(channel_skipDays) ""
    set column_array(channel_skipHours) ""
    set column_array(version) 2.0
    set column_array(image) "$image"
    set column_array(channel_link) "[ad_url]$package_url"
    return [array get column_array]
}

ad_proc -private news_update_rss {
    -summary_context_id
} {
    Regenerate RSS feed

    @author Dave Bauer (dave@thedesignexperience.org)
    @creation-date 2005-02-04

    @param summary_context_id

    @return

    @error
} {
    set subscr_id [rss_support::get_subscr_id \
                       -summary_context_id $summary_context_id \
                       -impl_name "news" \
                       -owner "news"]
    rss_gen_report $subscr_id

}


# add news notification
ad_proc -public news_notification_get_url {
       news_package_id
} {
       returns a full url to the news item.       
} { 
    return "[news_util_get_url $news_package_id]"
}

ad_proc -public news_do_notification {
    news_package_id
    news_id
} { 

    set package_id [ad_conn package_id]
    set community_id [dotlrn_community::get_community_id]
    set hr [string repeat "-" 70]

    # get the title and teaser for latest news item for the given package id
    if { [db_0or1row "get_news" "select item_id, title, lead, creation_user from cr_newsx where news_id = :news_id"] } {
        set read_more_url "[ad_url][news_util_get_url $news_package_id]/item?item_id=$item_id"
        set user [dotlrn::get_user_name $creation_user]
		if {$community_id != ""} {
    		set community_name [dotlrn_community::get_community_name $community_id]
			set new_content "[_ news.Community]: $community_name <br>"
		}
        append new_content "[_ news.Title]: $title <br>"
        append new_content "[_ news.Creation_User]: $user <br>"
        append new_content "$hr <br>"
    }
    
    set system_abreviation [ad_parameter -package_id [ad_acs_kernel_id]  PublisherName]
    
    set html_version $new_content
    append html_version "<br>[_ news.Read_more_about_it_at] <br><br>"
    append html_version "$hr <br>"
    

    # Notifies the users that requested notification for the specific news item

	# stop notification temporaly
    notification::new \
        -type_id [notification::type::get_type_id -short_name one_news_item_notif] \
        -object_id $news_package_id \
        -notif_subject "[_ news.News] - $title" \
        -notif_html $html_version

	#notification::new \
        -type_id [notification::type::get_type_id -short_name one_news_item_notif] \
        -object_id $news_package_id \
        -notif_subject "$system_abreviation - [_ news.News] - $title" \
        -notif_html $html_version

}

ad_proc -public news_order_reset {
    {-package_id:required}
} { 

	db_dml update_order {update cr_news set priority = null where package_id = :package_id}

} 

ad_proc -public news_order_item_set {
    {-news_id:required}
	{-order:required}
} { 

	db_dml update_order {update cr_news set priority = :order where news_id = :news_id}
}

ad_proc -public news_get_latest_news_html_options {
    {-package_id:required}
} { 

	return [db_list_of_lists get_items {
            select	to_char(publish_date, 'DD-MM-YYYY') || ' - ' ||  news_items_approved.publish_title,
            		news_items_approved.item_id
            from 	news_items_approved
            where 	package_id = :package_id
            order by 	news_items_approved.publish_date desc
            limit 15
 	}]
}

ad_proc -public news_get_mda_portlet_html {
    {-package_id:required}
} { 
	return [util_memoize "news_get_mda_portlet_html_not_cached -package_id $package_id"] 
}

ad_proc -public news_get_mda_portlet_html_not_cached {
    {-package_id:required}
} {

	set limit 10 
	set news_url [site_node::get_url_from_object_id -object_id $package_id]
	set num 1
	set more_news ""
	db_multirow -extend {image_id_size_2 image_id_size_3 image_id twitter_url video_id publish_body180 publish_body54 publish_body170} news_items select_news_items {} {
	
		set video_ids [application_data_link::get_linked_content -from_object_id $item_id -to_content_type videos_object]

		set video_id$num [lindex $video_ids 0]

		set item_id$num $item_id
	    	set publish_title [ad_html_to_text $publish_title]
	    	set publish_title$num $publish_title
	    	set publish_body [ad_html_to_text $publish_body]
	    	set publish_body$num $publish_body
		set view_url [export_vars -base "${news_url}item" { item_id }]
	  	set publish_body180$num [util_close_html_tags $publish_body "180" "180" "..." ""]
	   	set publish_body54$num [util_close_html_tags $publish_body "54" "54" "..." ""]
	   	set publish_body170$num [util_close_html_tags $publish_body "170" "170" "..." ""]

	
 		if {$num == 1} {
			set image_id$num [ImageMagick::util::get_image_id -item_id $item_id -name "max-priority-image"]
		} 
		if {$num > 1 && $num < 4} { 
			set image_id_size_2$num [ImageMagick::util::get_image_id -item_id $item_id -name "max-priority-image"]
			if {![exists_and_not_null image_id_size_2$num]} { 
				set image_id_size_2$num [ImageMagick::util::get_image_id -item_id $item_id -name "size-2"]
			}
		}
		if {$num > 3 && $num < 6} {
			set image_id_size_3$num [ImageMagick::util::get_image_id -item_id $item_id -name "max-priority-image"]
			if {![exists_and_not_null image_id_size_3$num]} {
				set image_id_size_3$num [ImageMagick::util::get_image_id -item_id $item_id -name "size-3"]
			}
		}


		if {![exists_and_not_null image_id$num]} {
			set image_id$num [ImageMagick::util::get_image_id -item_id $item_id -name_null 1]
		} else {
			set image_id_size_2$num $image_id
			set image_id_size_3$num $image_id
		}
	
		if {$num > 5} {
			append more_news "<li><strong>$publish_date_ansi</strong> <a href=\"${news_url}item?item_id=$item_id\">$publish_title</a></li>"
		}	
		
		set twitter_url [ad_urlencode "http://www.twitter.com/home?status=$publish_title"]
		set twitter_url "http://www.twitter.com/home?status=$publish_title"
		set var_item_id item_id$num
	
		lappend vars item_id$num [value_if_exists "item_id$num"]
		lappend vars video_id$num [value_if_exists video_id$num]
		lappend vars publish_title$num [value_if_exists publish_title$num]
		lappend vars publish_body$num [value_if_exists publish_body$num]
		lappend vars publish_body180$num [value_if_exists publish_body180$num]
		lappend vars publish_body54$num [value_if_exists publish_body54$num]
		lappend vars publish_body170$num [value_if_exists publish_body170$num]
		lappend vars image_id_size_2$num [value_if_exists image_id_size_2$num]
		lappend vars image_id_size_3$num [value_if_exists image_id_size_3$num]
		lappend vars image_id$num [value_if_exists image_id$num]
		
		incr num
	}

	lappend vars news_url $news_url
	lappend vars more_news $more_news
	set master ""
	set html [template::adp_parse "[acs_root_dir]/packages/news/templates/portal-mda-portlet-parse" $vars]
	return $html
}



# -----------------------------------------------
#    Replicates news item to another instanced of news package
    
#    @author Iuri Sampaio (iuri.sampaio@iurix.com)
#    @creation-date 2011-07-18
# -----------------------------------------------


ad_proc -public news_replicate_item {
    {-revision_id}
    {-imgfile ""}
    {-package_ids}
} {
        
    db_1row select_item_id {}
    
    set news_orig_item_id  $item_id
    
    db_1row select_news_info {}

    content::item::get -item_id $item_id -revision "latest" -array_name news

    if {![exists_and_not_null lang]} {
	set lang [lang::conn::locale]
    }

    set publish_title $news(title)
    set publish_date_ansi now
    set publish_body [db_string select_content {}]
    
    set mime_type "text/html"
    set live_revision_p f
    
    if {[ad_permission_p [ad_conn package_id] news_admin] || [string equal "open" [ad_parameter ApprovalPolicy "news" "open"]]} {
	set approval_user [ad_conn user_id]
	set approval_ip [ad_conn peeraddr]
	set approval_date $publish_date_ansi
	set confirm_url ""
    } else {
	set confirm_url needing-approval
        set approval_user [db_null]
        set approval_ip [db_null]
        set approval_date [db_null]
    }
    
    foreach package_id $package_ids {
	    
	set news_id [db_exec_plsql create_news_item {}]
		
	db_1row select_new_item_id {}
	
	if {[exists_and_not_null imgfile]} {
    
	    set image_id [ImageMagick::util::get_image_id -item_id $item_id]

	    set image_width_size [parameter::get -parameter WidthImageSize -default "480"]
	    
	    db_1row select_imgdescription {}

	    ImageMagick::util::create_image_item -file [template::util::file::get_property tmp_filename $imgfile] -parent_id $new_item_id -width $image_width_size -description $imgdescription
	    
	    ImageMagick::util::create_image_item -file [template::util::file::get_property tmp_filename $imgfile] -parent_id $new_item_id -name "size-2" -width 170 -description $imgdescription
		
	    ImageMagick::util::create_image_item -file [template::util::file::get_property tmp_filename $imgfile] -parent_id $new_item_id -name "size-3" -width 100 -description $imgdescription
	    
	}   
	
	relation_add "replicated_news" $news_orig_item_id $new_item_id
	
    }
}





ad_proc -public news_revise_replicated_item {
    {-revision_id}
    {-imgfile ""}
} {

    ns_log Notice "Running API news_revise_replicated_item $revision_id"

    db_1row select_item_id {}

    db_1row select_news_info {}

    content::item::get -item_id $item_id -revision "live" -array_name news


    if {![exists_and_not_null lang]} {
	set lang [lang::conn::locale]
    }

    set publish_title $news(title)
    set publish_date_ansi now
    set archive_date_ansi $archive_date
    set publish_body [db_string select_content {}]
    
    set mime_type "text/html"
    set live_revision_p t

    if {[ad_permission_p [ad_conn package_id] news_admin] || [string equal "open" [ad_parameter ApprovalPolicy "news" "open"]]} {
	set approval_user [ad_conn user_id]
	set approval_ip [ad_conn peeraddr]
	set approval_date $publish_date_ansi
	set confirm_url ""
    } else {
	set confirm_url needing-approval
        set approval_user [db_null]
        set approval_ip [db_null]
        set approval_date [db_null]
    }
    
    set image_id [ImageMagick::util::get_image_id -item_id $item_id]
    set imgdescription [db_string select_imgdescription {} -default ""]
    
    set replicated_revision_ids [db_string select_replicated_revision_ids {} -default ""]
    foreach replicated_revision_id $replicated_revision_ids {
	db_1row select_replicated_item_id {
	    SELECT item_id AS replicated_item_id FROM cr_items WHERE live_revision = :replicated_revision_id
	}

	set package_id [db_string select_package_id {}]

	set news_id [db_exec_plsql create_news_revision {}]

	if {[exists_and_not_null imgfile]} {
	    # ImageMagick package will check its tmp directory for the file, so no   
            # need to expand the path.

	    set image_width_size [parameter::get -parameter WidthImageSize -default "480"]
	    set image_id [ImageMagick::util::get_image_id -item_id $replicated_item_id -name_null 1]
	    set size-2-image_id [ImageMagick::util::get_image_id -item_id $replicated_item_id -name "size-2"]
	    set size-3-image_id [ImageMagick::util::get_image_id -item_id $replicated_item_id -name "size-3"]
	    
	    
	    if {$image_id != ""} {
		set image_item_id [content::revision::item_id -revision_id $image_id]
		ImageMagick::util::revise_image -file [template::util::file::get_property tmp_filename $imgfile] -item_id $image_item_id -width $image_width_size -description $imgdescription
	    } else {
		ImageMagick::util::create_image_item -file [template::util::file::get_property tmp_filename $imgfile] -parent_id $replicated_item_id -width $image_width_size -description $imgdescription
	    }
	    
	    if {${size-2-image_id} != ""} {
		set image_item_id [content::revision::item_id -revision_id ${size-2-image_id}]
		ImageMagick::util::revise_image -file [template::util::file::get_property tmp_filename $imgfile] -item_id $image_item_id -width 170 -description $imgdescription -name "size-2"
	    } else {
		ImageMagick::util::create_image_item -file [template::util::file::get_property tmp_filename $imgfile] -parent_id $replicated_item_id -name "size-2" -width 170 -description $imgdescription
	    }
	    
	    if {${size-3-image_id} != ""} {
		set image_item_id [content::revision::item_id -revision_id ${size-3-image_id}]
		ImageMagick::util::revise_image -file [template::util::file::get_property tmp_filename $imgfile] -item_id $image_item_id -width 100 -description $imgdescription -name "size-3"
	    } else {
		ImageMagick::util::create_image_item -file [template::util::file::get_property tmp_filename $imgfile] -parent_id $replicated_item_id -name "size-3" -width 100 -description $imgdescription
	    }
	    
	    
	} else {
	    set image_id [ImageMagick::util::get_image_id -item_id $replicated_item_id -name_null 1]
	    if {$image_id != ""} {
		ImageMagick::util::update_description -description $imgdescription -image_id $image_id
	    }
	}

	
	# Recursion Procedure. Edit all replicated items on cascade
	news_revise_replicated_item -revision_id $replicated_revision_id -imgfile $imgfile

    }
   
    return
}




ad_proc -public news_delete_replicated_items {
    id
} {

    Removes replicated items and relations on cascade
    
    @author Iuri Sampaio iuri.sampaio@iurix.com
    @creation-date 2011-08-01
} {
    
    set rels [db_list_of_lists select_rels {
	SELECT rel_id, object_id_two FROM acs_rels 
	WHERE rel_type = 'replicated_news' AND object_id_one = :id
    }]
    
    foreach elem $rels {
	set rel_id [lindex $elem 0]
	set object_id_two [lindex $elem 1]

	relation_remove $rel_id
		
	news_items_delete $object_id_two	
    }

    return
}


