# /packages/news/www/item-create.tcl

ad_page_contract {

    This page enables registered users and the news-admin 
    to enter news releases.

    @author stefan@arsdigita.com
    @creation-date 2000-11-14
    @cvs-id $Id: item-create.tcl,v 1.4 2006/11/09 12:21:54 alessandrol Exp $

} {
    {publish_title {}}
    {publish_lead {}}
    {publish_body:allhtml {}}
    {html_p {}}
    {publish_date_ansi {now}}
    {permanent_p {}}
    {item_id:optional}
} -properties {
    title:onevalue
    context:onevalue
    publish_date_select:onevalue
    immediate_approve_p:onevalue
}

set title "[_ news.Create_News_Item]"
set context [list $title]

# Authorization by news_create
set package_id [ad_conn package_id]
ad_require_permission $package_id news_create

set maxlength [parameter::get -parameter TitleMaxLength -default ""]

set image_width_size [parameter::get -parameter WidthImageSize -default "480"]

# Furthermore, with news_admin privilege, items are approved immediately
# or if open approval policy 

if {[ad_permission_p $package_id news_admin] || [string equal "open" [ad_parameter ApprovalPolicy "news" "open"]]} {
    set immediate_approve_p 1
} else {
    set immediate_approve_p 0
}

set return_url ""
ad_form -name news \
    -cancel_url [ad_decode $return_url "" "." $return_url] \
	-html {enctype multipart/form-data} \
    -form {
        {publish_title:text
            {label "[_ news.Title]"}
            {html {size 50 maxlength {$maxlength}}}}
		{approval_user:text(hidden),optional}
        {approval_ip:text(hidden),optional}
        {approval_date:text(hidden),optional}
        {creation_ip:text(hidden),optional}
        {live_revision_p:text(hidden),optional}
        {publish_lead:text(hidden),optional}
        {user_id:text(hidden),optional}
        {publish_date_select:text(text),optional
			{label "[_ news.publish_date_select]"}
        	{html {id sel1} }
        	{after_html {<input type='button' value=' ... ' onclick=\"return showCalendar('publish_date_select', 'y-m-d');\">  <div class="form-help-text"><img src="/shared/images/info.gif" width="12" height="9" alt="\[i\]" title="Help text" border="0"> [_ calendar.ymd]</div> }}}
        {confirm_url:text(hidden),optional}
        {imgfile:file,optional
				{label "#news.Image#"}
		}
		{imgdescription:text,optional
			{label "#news.Image_description#"}
		}
       } \
    -export {return_url} 

if { $immediate_approve_p } {
    element set_value news approval_user [ad_conn user_id]
    element set_value news approval_ip [ad_conn peeraddr]
    element set_value news creation_ip [ad_conn peeraddr]
    element set_value news confirm_url ""
} else {
    element set_value news confirm_url needing-approval
    element set_value news approval_user [db_null]
    element set_value news approval_ip [db_null]
    element set_value news approval_date [db_null]
}

element set_value news user_id [ad_conn user_id]
element set_value news live_revision_p f


ad_form -extend -name news -form {
    	{publish_body:richtext(richtext),nospell,optional
            {label "[_ news.publish_body]"}
            {html {cols 60 rows 20}}}
		{publish_doc:file,optional}
		{priority:text(radio)
			{label "[_ news.Priority]"}
			{options {{#news.Max_priority# 0} {#news.Normal_priority# 3}}}
		}
} -validate {
        {publish_body 
		{[exists_and_not_null publish_body] || [exists_and_not_null publish_doc]}
         		"Você precisa preencher o campo conteúdo ou enviar um arquivo .DOC para criar a notícia."
        }
}


if {![empty_string_p [category_tree::get_mapped_trees $package_id]]} {
        ad_form -extend -name news -form {
            {category_ids:integer(category),multiple {label "[_ news.Categories]"}
                {html {size 3}} {value {}}
            }
        }
}

set lang_enable_p [parameter::get -parameter LangEnableP -default 0]
if {$lang_enable_p} {
	 foreach lang_option [lang::system::get_locales] {
			lappend options [list $lang_option $lang_option]
	 }

     ad_form -extend -name news -form {
            {lang:text(select) {label "[_ news.Lang]"}
                {options $options}
            }
     }

     element set_value news lang [lang::conn::locale]
}


set replicate_item_p [parameter::get -package_id $package_id -parameter "ReplicateNewsItemP" -default 0]

if {$replicate_item_p} {
    
    set package_options [db_list_of_lists select_packages {
	SELECT ap1.instance_name || ' - ' || ap2.instance_name, ap1.package_id
	FROM site_nodes sn2, site_nodes sn1, apm_packages ap2, apm_packages ap1
	WHERE sn2.name IN ('s1', 's2', 'aegre', 'territriosrurais', 'plano-safra', 'terralegal', 'saf', 'sdt', 'sra', 'condraf', 'ouvidoria')
	AND ap2.instance_name != 'Terra Legal Amazônia'
	AND sn2.object_id = ap2.package_id
	AND sn1.object_id = ap1.package_id
	AND sn1.parent_id = sn2.node_id
	AND ap1.package_key = 'news'
    }]
        

    ad_form -extend -name news -form {
	{package_ids:integer(multiselect),multiple,optional
	    {label "Replicar a notícia nos sites"}
	    {options $package_options}
	    {help_text "You can choose more than one value!"}
	}
    } 
}


ad_form -extend -name news -on_submit {
        
    if {$publish_date_select == "" && $immediate_approve_p} {
	set publish_date_select now
    }
    
    if {![exists_and_not_null lang]} {
	set lang [lang::conn::locale]
    }
    
    set publish_date_ansi $publish_date_select
    set approval_date $publish_date_select
    set publish_body [template::util::richtext::get_property contents $publish_body]
    #set publish_body [ad_convert_to_html $publish_body]
    
    
    set mime_type "text/html"
    set package_id [ad_conn package_id]
    

    if {[exists_and_not_null publish_doc]} {
	set publish_file_name [ns_mktemp "/tmp/html-XXXXXXXX"]
	catch {exec abiword --to=html --to-name=$publish_file_name [template::util::file::get_property tmp_filename $publish_doc]}
	set fd [open $publish_file_name r]
	set publish_body [read $fd]
	
	close $fd
	file delete $publish_file_name
	
	set start [string first "<div>" $publish_body]
	set end [string first "</body>" $publish_body]
	set publish_body [string range $publish_body [expr $start +5] [expr $end - 9]]
	
    }
    
    set news_id [db_exec_plsql create_news_item {}]
 
    set tmpfile ""

    if {[exists_and_not_null imgfile]} {
	# Copy original image to avoid distortion
	set tmp_filename [ns_tmpnam]
	file copy [lindex $imgfile 1] $tmp_filename
	set tmp_name  [lindex $imgfile 0]
	set tmpfile "$tmp_name $tmp_filename"



	# ImageMagick package will check its tmp directory for the file, so no
	# need to expand the path.
	db_1row item {
	    select item_id from cr_revisions where revision_id = :news_id
	}
	
	ImageMagick::util::create_image_item -file [template::util::file::get_property tmp_filename $imgfile] -parent_id $item_id -width $image_width_size -description $imgdescription
	
	ImageMagick::util::create_image_item -file [template::util::file::get_property tmp_filename $imgfile] -parent_id $item_id -name "size-2" -width 170 -description $imgdescription
	
	ImageMagick::util::create_image_item -file [template::util::file::get_property tmp_filename $imgfile] -parent_id $item_id -name "size-3" -width 100 -description $imgdescription
	
    } 
    
    db_1row item {
	select item_id from cr_revisions where revision_id = :news_id
    }
    
    if {[exists_and_not_null category_ids]} {
	category::map_object -object_id $item_id $category_ids
    }
    
    
    
    if { $immediate_approve_p && [apm_package_installed_p dotlrn]} {
	news_do_notification $package_id $news_id
    }
    
    util_memoize_flush_regexp "news*"
    
    if {$replicate_item_p && [exists_and_not_null package_ids]} {
	news_replicate_item -revision_id $news_id -imgfile $tmpfile -package_ids $package_ids
    }
    
    set preview_item_p [parameter::get -package_id $package_id -parameter "PreviewNewsItemP" -default 0]

    if {$preview_item_p} {
	ad_returnredirect [export_vars -base preview { item_id }]
	ad_script_abort
    } else {
	
	if {$immediate_approve_p} {
	    ad_returnredirect [export_vars -base item { item_id }]
	} else {
	    ad_returnredirect $confirm_url
	}
	
	ad_script_abort
    }
} 


