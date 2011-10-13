ad_page_contract {
  This is a form to upload sound 

  @author Alessandro Landim

  $Id: site-master.tcl,v 1.22.2.7 2007/07/18 10:44:06 emmar Exp $
} {
	{sound_id:optional}
	{sound:trim,optional}
}

permission::require_permission -party_id [ad_conn user_id] -object_id [ad_conn package_id] -privilege write

ad_form -html { enctype multipart/form-data } -name sound-new -form {
		{sound_id:key}
		{sound:file {label "#sounds.file#"}}
}


if {[exists_and_not_null sound]} {
	ad_form -extend -name sound-new -validate {
        {sound 
		{[string equal [lindex [split [template::util::file::get_property mime_type $sound] "/"] 0] "audio"]}
         	"#sounds.This_file_isnt_sound_file#"
        }
	}
}



set category_ids [list]
foreach {category_id category_name} [sounds::get_categories -package_id [ad_conn package_id]] {
    ad_form -extend -name sound-new -form [list \
					   [list "cat_${category_id}:integer(select)" \
						[list label "${category_name}"] \
						[list options [sounds::category_get_options -parent_id $category_id]] \
						[list value   ""] \
					       ] \
					      ]
}

ad_form -extend -name sound-new -form {
	{name:text {label "#sounds.name#"}}
	{description:richtext(richtext),optional,nospell {label "#sounds.description#"}}
	{publish_date_select:text(text)
			{label "[_ sounds.publish_date_select]"}
        	{html {id sel1} }
        	{after_html {<input type='button' value=' ... ' onclick=\"return showCalendar('publish_date_select', 'y-m-d');\">  <div class="form-help-text"><img src="/shared/images/info.gif" width="12" height="9" alt="\[i\]" title="Help text" border="0"> [_ calendar.ymd]</div> }}}


} -edit_request {

	db_1row get_sound_info {select sound_name as name, sound_description as description, publish_date as publish_date_select from sounds where sound_id = :sound_id}
	set description [list $description]
	template::util::richtext::set_property contents $description $description
} -on_submit {

    set description [template::util::richtext::get_property contents $description]

} -edit_data {

	sounds::edit -sound_id $sound_id -name $name -description $description -publish_date $publish_date_select

} -new_data {
	
	set tmp_filename [template::util::file::get_property tmp_filename $sound]
	set filename [template::util::file::get_property filename $sound] 
	set n_bytes [file size $tmp_filename]
	set user_id [ad_conn user_id]
	set package_id [ad_conn package_id]
	set guessed_file_type [template::util::file::get_property mime_type $sound]
        
	
	sounds::new -filename $filename -tmp_filename $tmp_filename \
			    -name $name \
			    -n_bytes $n_bytes -guessed_file_type $guessed_file_type \
			    -description $description \
			    -queue 1 \
				-user_id $user_id \
			    -package_id $package_id \
			    -date $publish_date_select

} -after_submit {
	ad_returnredirect "."
    ad_script_abort
}
