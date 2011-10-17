# /packages/news/www/item.tcl

ad_page_contract {
    
    Page to view one item (live or archived) in its active revision
    @author stefan@arsdigita.com
    @creation-date 2000-12-20
    @cvs-id $Id: item.tcl,v 1.4 2006/10/18 13:37:27 alessandrol Exp $
    
} {

    item_id:integer,notnull

} -properties {
    title:onevalue
    context:onevalue 
    item_exist_p:onevalue
    publish_title:onevalue
    publish_date:onevalue
    publish_body:onevalue
    html_p:onevalue
    creator_link:onevalue
    comments:onevalue
    comment_link:onevalue
}

template::head::add_css -href "/resources/acs-templating/fontsize/font-size.css"
template::head::add_javascript -src "/resources/acs-templating/fontsize/font-size.js"


set user_id [ad_conn untrusted_user_id]
set package_id [ad_conn package_id]
set package_url [ad_conn package_url]
set site_url [ad_url]
set return_url [ad_return_url]
ah::requires -sources "lightboxJS"
# live view of a news item in its active revision


set file_list ""
set videos_list ""
set sounds_list ""



#set live_revision [content::item::get_live_revision -item_id $item_id]
set live_revision [db_string get_live_revision {select revision_id from cr_revisions where item_id = :item_id order by revision_id desc limit 1} -default ""]
set lang_enable_p [parameter::get -parameter LangEnableP -default 0]
if {$lang_enable_p} {
	set user_locale [lang::conn::locale]
	set lang_live_revision [db_string get_lang_live_revision {select revision_id from cr_revisions where item_id = :item_id and nls_language = :user_locale order by revision_id desc limit 1} -default 0]

	if {$lang_live_revision != 0} {
		set live_revision $lang_live_revision
	}
} 


set item_exist_p [db_0or1row one_item {}]




set publish_title_one $publish_title
set item_id_orig $item_id
if { $item_exist_p } {

    permission::require_permission \
	-object_id $item_id \
	-party_id  $user_id \
	-privilege read
    
    set publish_body [db_string get_content "select  content
	from    cr_revisions
	where   revision_id = :live_revision"]
    
    
    # text-only body
    if {[info exists html_p] && [string equal $html_p "f"]} {
	set publish_body [ad_text_to_html -- $publish_body]
    }
    
    regsub -all {size=} $publish_body {removed=} publish_body
    regsub -all {color=} $publish_body {removed=} publish_body
    
    set confirm_link ""
    set edit_link ""
    set delete_link ""
    
    
    if {[permission::permission_p -object_id $item_id -privilege news_admin] } {
	set publish_item_url [export_vars -base item-publish {{ revision_id $live_revision}}]
	set edit_item_url [export_vars -base item-edit {{ revision_id $live_revision}}]
	set delete_item_url [export_vars -base admin/process {{action delete} {n_items $item_id}}] 
			   
        
    }

    set image_width_size [parameter::get -parameter WidthImageSize -default "480"]
    
    set title $publish_title
    set context [list $title]
    set publish_title {}
    
    set user_id [ad_conn user_id]
    set displayed_object_id $item_id
    
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
    
    
    
} else {
    set context {}
    set title "[_ news.Error]"
    set SolicitRatingP 0
}


if {![exists_and_not_null image_details(description)]} {
    set image_details(description) ""
}




