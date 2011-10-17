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
	
	set limit 4
	set has_max_priority [db_list get_max_priority_item {}]
	set hide_item ""

	if {$has_max_priority != ""} {
		set limit 3
		set list_of_items $has_max_priority
		set hide_item "and news_items_approved.item_id <> $has_max_priority"
	}

	append list_of_items " "
	append list_of_items  [db_list list_of_items {} ]
	set priority_item 0


	db_multirow -extend {order image_id twitter_url} news_items select_news_items {} {
		set order 1
		if {$priority == 0 && $priority_item == 0} {
			set order  0
			set priority_item 1
		}

		set publish_title [ad_html_to_text $publish_title]
	    set publish_body [ad_html_to_text $publish_body]
	 
	    set publish_date [lc_time_fmt $publish_date_ansi "%x"]
	    set view_url [export_vars -base "${url}item" { item_id }]
	    set publish_body [util_close_html_tags $publish_body "180" "180" "..." ""]
 
		set image_id [ImageMagick::util::get_image_id -item_id $item_id -name "max-priority-image"]
		if {$image_id == ""} {
			set image_id [ImageMagick::util::get_image_id -item_id $item_id -name_null 1]
		}
		
		set twitter_url [ad_urlencode "http://www.twitter.com/home?status=$publish_title"]
		set twitter_url "http://www.twitter.com/home?status=$publish_title"



	}
	template::multirow sort news_items -dictionary order 

