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
set user_id [ad_conn user_id]
template::head::add_css -href "/resources/news/news.css"

set javascript_gallery_p [parameter::get -package_id $package_id -parameter JavascriptGallery -default 0]
if {$javascript_gallery_p} {
	template::head::add_javascript -src "/resources/news/cu3er/js/swfobject/swfobject.js" -order 1
	template::head::add_javascript -script "
			var flashvars = {};
			flashvars.xml = \"${news_url}rss/cube.xml\";
			flashvars.font = \"font.swf\";
			var attributes = {};
			attributes.wmode = \"transparent\";
			attributes.id = \"slider\";
			swfobject.embedSWF(\"/resources/news/cu3er/cu3er.swf\", \"cu3er-container\", \"570\", \"300\", \"9\", \"/resources/news/cu3er/js/swfobject/expressInstall.swf\", flashvars, attributes);
		" -order 9
}
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

set hide_items_where_clause ""

set priority_sql "priority = 0"
set has_max_priority [db_string max_priority_item2 {} -default 0]
if {$has_max_priority == 0} {
	set priority_sql "priority <> 0"
}

set i 1
set active ""
set hide "hide"
set max_priority_list ""
### get 3 max priority items
	
	
if {$javascript_gallery_p} {

	### pega a lista de notícias que já foi no cu3er
	set max_priority_list [db_list select_max_priority_items_list {}]
	set max_priority_html 1

	#db_multirow -extend { image_id publish_date view_url } max_priorities select_max_priority_items {} {
	#	set publish_date [lc_time_fmt $publish_date_ansi "%x"]
	#	set view_url [export_vars -base "${url}item" { item_id }]
	#
	#	set publish_title [ad_html_to_text $publish_title]
	#	set publish_body [ad_html_to_text $publish_body]
	   
	#       	set publish_body [util_close_html_tags $publish_body "150" "150" " ..." ""]
	    
		#ratings
	#	set image_id [ImageMagick::util::get_image_id -item_id $item_id -name "max-priority-image"]
	#	if {$image_id == ""} {
	#		set image_id [ImageMagick::util::get_image_id -item_id $item_id -name_null 1]
	#	}

	#	if {$i == 3} {
	#			set active "active"
	#			set hide "gallery_max_priority"
	#	}

	#	append max_priority_html "<div name=\"max_priority\" class=\"$hide\" id=\"max_priority$i\">\n"
	#	append max_priority_html "<a href=\"${url}item?item_id=$item_id\" title=\"$publish_title\"><img width=\"430\" height=\"275\" src=\"${url}image/$image_id\" alt=\"$publish_title\" /></a>\n"
	#	append max_priority_html "<div class=\"info_max_priority\">\n"
	#	append max_priority_html "<h4><a href=\"${url}item?item_id=$item_id\" title=\"$publish_title\">$publish_title</a></h4>\n"
	#	append max_priority_html "<p><a href=\"${url}item?item_id=$item_id\" title=\"$publish_title\">$publish_body</a></p>\n"
	#	append max_priority_html "</div>\n"
	#	append max_priority_html "</div>\n"
	#	append max_priority_options "<li class=\"showNews $active\" id=\"$i\">$publish_title</li>\n"
	#	lappend max_priority_list $item_id
	#
	#	incr i

	#}
} 

if {![string equal $max_priority_list ""]} {
	set hide_items_where_clause "and item_id not in ([join $max_priority_list ,])"
} else {
	set hide_items_where_clause ""
}
	

	
set has_max_priority [db_string max_priority_item2 {} -default 0]
if {$has_max_priority == 0} {
        set priority_sql "priority <> 0"
}

db_0or1row max_priority_item {}
if {[exists_and_not_null max_priority_item_id]} {
	if { [string length $max_priority_publish_body] > 180} {
	 set max_priority_publish_body [ad_html_to_text $max_priority_publish_body]
	 set max_priority_publish_body [util_close_html_tags $max_priority_publish_body "180" "180" "..." ""]
	}
	
	set max_priority_image_id [ImageMagick::util::get_image_id -item_id $max_priority_item_id -name "max-priority-image"]
	if {$max_priority_image_id == ""} {
		set max_priority_image_id [ImageMagick::util::get_image_id -item_id $max_priority_item_id -name_null 1]
	}

	lappend max_priority_list $max_priority_item_id
}

if {![string equal $max_priority_list ""]} {
	set hide_items_where_clause "and item_id not in ([join $max_priority_list ,])"
} else {
	set hide_items_where_clause ""
}

## get 3 others news

db_multirow -extend { image_id publish_date view_url rss_exists rss_url notification_chunk ratings_stars solicit_rating_p} news_items select_news_items {} {
    set publish_title [ad_html_to_text $publish_title]
    set publish_body [ad_html_to_text $publish_body]
 
    set publish_date [lc_time_fmt $publish_date_ansi "%x"]
    set view_url [export_vars -base "${url}item" { item_id }]
    set publish_body [util_close_html_tags $publish_body "180" "180" "..." ""]
}

