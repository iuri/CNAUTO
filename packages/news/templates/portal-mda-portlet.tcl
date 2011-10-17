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


template::head::add_css -href "/resources/news/news.css"

set javascript_gallery_p [parameter::get -package_id $package_id -parameter JavascriptGallery -default 0]
set admin_p [permission::permission_p -object_id $package_id -party_id [ad_conn user_id] -privilege admin]

set news_url [site_node::get_url_from_object_id -object_id $package_id]

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


set html [news_get_mda_portlet_html -package_id $package_id]
