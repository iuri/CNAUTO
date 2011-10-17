#
#  Copyright (C) 2001, 2002 MIT
#
#  This file is part of dotLRN.
#
#  dotLRN is free software; you can redistribute it and/or modify it under the
#  terms of the GNU General Public License as published by the Free Software
#  Foundation; either version 2 of the License, or (at your option) any later
#  version.
#
#  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
#  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
#  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
#  details.
#

#
# /news-portlet/www/news-portlet.tcl
#
# arjun@openforce.net
#
# The logic for the news portlet
#
# $Id: news-portlet.tcl,v 1.18.2.4 2007/03/04 22:49:45 nimam Exp $
# 

	set news_url [site_node::get_url_from_object_id -object_id $package_id]

	template::head::add_css -href "/resources/news/news.css"

	set javascript_gallery_p [parameter::get -package_id $package_id -parameter JavascriptGallery -default 0]
	set admin_p [permission::permission_p -object_id $package_id -party_id [ad_conn user_id] -privilege admin]

	# Should be a list already! XXX rename me!
	set list_of_package_ids $package_id
	set one_instance_p [ad_decode [llength $list_of_package_ids] 1 1 0]

	set display_item_content_p [parameter::get_from_package_key -package_key news-portlet -parameter display_item_content_p -default 0]
	set display_subgroup_items_p [parameter::get_from_package_key -package_key news-portlet -parameter display_subgroup_items_p -default 0]
	set display_item_attribution_p [parameter::get_from_package_key -package_key news-portlet -parameter display_item_attribution_p -default 1]


	if { $display_item_content_p } {
	    #Only pull out the full content if we have to.
	    set content_column " , content as publish_body, html_p "
	} else {
	    set content_column ""
	}	
	
	set limit 5
	set has_max_priority [db_list get_max_priority_item {}]
	set hide_item ""

	if {$has_max_priority != ""} {
		set list_of_items $has_max_priority
		set hide_item "and news_items_approved.item_id <> $has_max_priority"
	}

	append list_of_items " "
	append list_of_items  [db_list list_of_items {} ]
	if {[string trim $list_of_items] eq ""} {
		set list_of_items 0
	}
	set priority_item 0

	set lang_enable_p [parameter::get -parameter LangEnableP -package_id $package_id -default 0]
	set user_locale [lang::conn::locale]

	db_multirow -extend {order image_id_size_3 twitter_url image_id} news_items select_news_items {} {
	    set order 1
	    if {$priority == 0 && $priority_item == 0} {
			set order  0
			set priority_item 1
	    }

		if {$lang_enable_p} {
			set lang_revision [db_string get_lang_live_revision {select revision_id from cr_revisions where item_id = :item_id and nls_language = :user_locale order by revision_id desc limit 1} -default 0]
				 

			if { $lang_revision != 0 } {
				set publish_title [db_string get {select publish_title  from   news_item_revisions where  revision_id  = :lang_revision} -default ""]
				set publish_body [db_string get {select publish_title from   news_item_revisions where  revision_id  = :lang_revision} -default ""]
			}

 

		} 


		

	    set publish_title [ad_html_to_text $publish_title]
	    set publish_body [ad_html_to_text $publish_body]
	 
	    set publish_date [lc_time_fmt $publish_date_ansi "%x"]
	    set view_url [export_vars -base "${url}item" { item_id }]
	    set publish_body_orig $publish_body
	    set publish_body [util_close_html_tags $publish_body "180" "180" "..." ""]
 

	    set image_id [ImageMagick::util::get_image_id -item_id $item_id -name_null 1]
	    set image_id_size_3 [ImageMagick::util::get_image_id -item_id $item_id -name "size-3"]
		if {$order == 0} {
			set image_id_size_3 [ImageMagick::util::get_image_id -item_id $item_id -name "max-priority-image"]
	    	set publish_body [util_close_html_tags $publish_body_orig "350" "350" "..." ""]
		}
   	    if {$image_id_size_3 == ""} {
	    	set publish_body [util_close_html_tags $publish_body_orig "195" "195" "..." ""]
	        set image_id_size_3 [ImageMagick::util::get_image_id -item_id $item_id -name_null 1]
	    }
	}
	template::multirow sort news_items -dictionary order 

