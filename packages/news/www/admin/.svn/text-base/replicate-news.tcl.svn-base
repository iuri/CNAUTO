ad_page_contract {

    Replicates news to another subsite
} {
    {revision_id ""}
    {return_url ""}
} 


set page_title "[_ news.Replicate_News_Item]"
set context [list $page_title]

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


ad_form -name instances -form {
    {revision_id:integer(hidden)
	{value $revision_id}
    }
    {package_ids:integer(multiselect),multiple
	{label "Packages"}
	{options $package_options}
	{help_text "You can choose more than one value!"}
    }
    {return_url:text(hidden) {value $return_url}}
} -on_submit {
    
    
    db_1row select_item_id {
      SELECT item_id 
      FROM cr_revisions
      WHERE revision_id = :revision_id 

    }
    
    set news_orig_item_id  $item_id
    
    db_1row select_news_info {
	SELECT lead AS publish_lead, priority
	FROM cr_news
	WHERE news_id = :revision_id 
    }

    content::item::get -item_id $item_id -revision "latest" -array_name news

    if {![exists_and_not_null lang]} {
	set lang [lang::conn::locale]
    }

    set publish_title $news(title)
    set publish_date_ansi now
    set publish_body [db_string select_content {
      SELECT content 
      FROM cr_revisions 
      WHERE revision_id = :revision_id
      

    }]
    
    set mime_type "text/html"
    
    if {[ad_permission_p [ad_conn package_id] news_admin] || [string equal "open" [ad_parameter ApprovalPolicy "news" "open"]]} {
	set approval_user [ad_conn user_id]
	set approval_ip [ad_conn peeraddr]
	set approval_date $publish_date_ansi
	set live_revision_p t
	set confirm_url ""
    } else {
	set confirm_url needing-approval
	set live_revision_p f
        set approval_user [db_null]
        set approval_ip [db_null]
        set approval_date [db_null]
    }
    
    
    set image_id [ImageMagick::util::get_image_id -item_id $item_id]

    if {[exists_and_not_null image_id]} {
	
	set image_path [content::revision::get_cr_file_path -revision_id $image_id]
	set image_width_size [parameter::get -parameter WidthImageSize -default "480"]

	db_1row select_imgdescription {
	    SELECT description AS imgdescription
	    FROM cr_revisions
	    WHERE revision_id = :image_id
	    
	}
	
	set tmp_filename "/tmp/image-[ns_rand 1000000].jpeg"
	
	if {![catch { exec cp $image_path $tmp_filename} errorMsg]} {
	    # do nothing
	} 
    }
    
    
    foreach package_id $package_ids {
	
	set news_id [db_exec_plsql create_news_item {

	    SELECT news__new(
			     null,               -- p_item_id
			     null,              -- p_locale
			     :publish_date_ansi, -- p_publish_date
			     :publish_body,      -- p_text
			     :lang,               -- p_nls_language
			     :publish_title,     -- p_title
			     :mime_type,         -- p_mime_type
			     :package_id,        -- p_package_id
			     null,               -- p_archive_date
			     :approval_user,     -- p_approval_user
			     :approval_date,     -- p_approval_date
			     :approval_ip,       -- p_approval_ip
			     null,               -- p_relation_tag
			     :approval_ip,       -- p_creation_ip
			     :approval_user,     -- p_creation_user
			     :live_revision_p,   -- p_is_live_p
			     :publish_lead,      -- p_lead
			     :priority           -- p_priority
			     );
	}]
	
	
	db_1row select_new_item_id {
	    SELECT item_id AS new_item_id
	    FROM cr_revisions
	    WHERE revision_id = :news_id


	}
	
	if {[exists_and_not_null image_id]} {
	    # ImageMagick package will check its tmp directory for the file, so no
	    # need to expand the path.
	    set mime_type [ns_guesstype $tmp_filename]

	    set imgfile "tmpfile $tmp_filename content-type $mime_type"	    
	    
	    ImageMagick::util::create_image_item -file [template::util::file::get_property tmp_filename $imgfile] -parent_id $new_item_id -width $image_width_size -description $imgdescription
	    
	    ImageMagick::util::create_image_item -file [template::util::file::get_property tmp_filename $imgfile] -parent_id $new_item_id -name "size-2" -width 170 -description $imgdescription
		
	    ImageMagick::util::create_image_item -file [template::util::file::get_property tmp_filename $imgfile] -parent_id $new_item_id -name "size-3" -width 100 -description $imgdescription
	    
	}   
    }
    
    relation_add "replicated_news" $news_orig_item_id $new_item_id
    
    util_memoize_flush_regexp "news*"
	
} -after_submit {

	
	ad_returnredirect $return_url
	ad_script_abort
    }
