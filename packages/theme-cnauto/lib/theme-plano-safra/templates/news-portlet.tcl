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


set package_id [ad_conn package_id]

set news_package_id [db_string select_package_id {} -default ""]



set news_url [site_node::get_url_from_object_id -object_id $news_package_id]


set admin_p 1
#[permission::permission_p -object_id $news_package_id -party_id [ad_conn user_id] -privilege admin]
# Should be a list already! XXX rename me!
set list_of_package_ids $news_package_id
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
	
set limit 2

db_multirow -extend {image_id_size_2 image_id_size_3 image_id twitter_url video_id publish_body150 view_url} news_items select_news_items {} {
	set video_ids [application_data_link::get_linked_content -from_object_id $item_id -to_content_type videos_object]

	set video_id [lindex $video_ids 0]

    	set publish_title [ad_html_to_text $publish_title]
    	set publish_body [ad_html_to_text $publish_body]
	set view_url [export_vars -base "${news_url}item" { item_id }]
  	set publish_body150 [util_close_html_tags $publish_body "150" "150" "..." ""]



}


