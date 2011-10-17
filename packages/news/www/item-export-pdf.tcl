# /packages/news/www/item.tcl

ad_page_contract {
    
    Page to view one item (live or archived) in its active revision
    @author stefan@arsdigita.com
    @creation-date 2000-12-20
    @cvs-id $Id: item.tcl,v 1.4 2006/10/18 13:37:27 alessandrol Exp $
    
} {
    item_id:integer,notnull
}


set user_id [ad_conn untrusted_user_id]
set package_id [ad_conn package_id]
set package_url [ad_conn package_url]
set site_url [ad_url]
set item_exist_p [db_0or1row one_item "
select item_id,
       live_revision,
       publish_title,
       html_p,
       to_date(publish_date, 'DD/MM/YYYY HH:MI') as publish_date,
       '<a href=/shared/community-member?user_id=' || creation_user || '>' || item_creator ||  '</a>' as creator_link
from   news_items_live_or_submitted
where  item_id = :item_id"]
set publish_title_one $publish_title
set item_id_orig $item_id
if { $item_exist_p } {

	permission::require_permission \
    		-object_id $item_id \
    		-party_id  $user_id \
    		-privilege read


    # workaround to get blobs with >4000 chars into a var, content.blob_to_string fails! 
    # when this'll work, you get publish_body by selecting 'publish_body' directly from above view
    #
    # RAL: publish_body is already snagged in the 1st query above for postgres.
    #
    set get_content [db_map get_content]
    if {![string match "" $get_content]} {
	set publish_body [db_string get_content "select  content
	from    cr_revisions
	where   revision_id = :live_revision"]
    }

    # text-only body
    if {[info exists html_p] && [string equal $html_p "f"]} {
	set publish_body [ad_text_to_html -- $publish_body]
    }
    
    regsub -all {size=} $publish_body {removed=} publish_body
    regsub -all {color=} $publish_body {removed=} publish_body
    if { [ad_parameter SolicitCommentsP "news" 0] && [ad_permission_p $item_id general_comments_create] } {
	set comment_link [general_comments_create_link $item_id "[ad_conn package_url]item?item_id=$item_id"]
	set comments [general_comments_get_comments -print_content_p 1 -print_attachments_p 1 \
		$item_id "[ad_conn package_url]item?item_id=$item_id"]
    } else {
	set comment_link ""
        set comments ""
    }
	
	set videos_package_id [site_node_apm_integration::get_child_package_id -package_id $package_id -package_key videos]
	set sounds_package_id [site_node_apm_integration::get_child_package_id -package_id $package_id -package_key sounds]
	set fs_package_id [site_node_apm_integration::get_child_package_id -package_id $package_id -package_key file-storage]
	set attach_p 0
	set attach_link ""
	set delete_link ""
	set image_edit_link ""
    set edit_link ""
	if {$videos_package_id != "" || $sounds_package_id != "" || $fs_package_id != ""} {
		set attach_p 1
	}


    if {[permission::permission_p -object_id $item_id -privilege news_admin] } {
        set edit_link "<a href=\"item-edit?item_id=$item_id\">#news.Revise#</a>"
        set delete_link "<a href=\"admin/process?action=delete&n_items=$item_id\">#news.Delete#</a>"
	set image_edit_link "<a href=\"image-edit?item_id=$item_id\">#news.Revise_image#</a>"
        if {$attach_p} {
			set attach_link "<a href=\"item-attach-file?item_id=$item_id\">#news.Attach_file#</a>"
		}
	}

	set image_width_size [parameter::get -parameter WidthImageSize -default "480"]

    set title $publish_title
    set context [list $title]
    set publish_title {}
   
    set user_id [ad_conn user_id]
    set displayed_object_id $item_id


    set SolicitRatingP [parameter::get -parameter SolicitRatingP -package_id [ad_conn package_id] -default 1]


	set rate_form [ratings::form -object_id $displayed_object_id]
	set current_rating [ratings::get -object_id $displayed_object_id -user_id $user_id]
	array set ratings [ratings::aggregates::get -object_id $displayed_object_id]
	
	if {[info exists ratings(all_rating_ave)]} {
    		set ratings(stars) [ratings::icon::html_fragment -rating $ratings(all_rating_ave)]
	} else {
    		set ratings(all_ratings) 0
    		set ratings(stars) {}
	}
	if {![empty_string_p $current_rating]} {
	    set stars [ratings::icon::html_fragment -rating $current_rating]
	}
	


	set image_id [ImageMagick::util::get_image_id -item_id $item_id -name_null 1]


	if {![empty_string_p $image_id]} { 
	  	set publish_image "./image/$image_id"
		set image_item_id [content::revision::item_id -revision_id $image_id]
	
		content::item::get -item_id $image_item_id -array_name image_details
	} else {
	  set publish_image ""
	}


	set publish_body54 [util_close_html_tags $publish_body "120" "120" "..." ""]

	template::head::add_meta -name "og:title" -content $title 
	template::head::add_meta -name "og:description" -content $publish_body54
	if {[exists_and_not_null image_id]} {
		template::head::add_meta -name "og:image" -content "${site_url}${package_url}image/$image_id"
	}

	set pdf_file [text_templates::create_pdf_from_html -html_content "<h1>$title</h1> $publish_body <p>Original: <a href=\"${site_url}${package_url}item?item_id=$item_id\">${site_url}${package_url}item?item_id=$item_id</a></p>"]
	ns_returnfile 200 application/pdf $pdf_file
	file delete $pdf_file
	ad_script_abort

}


