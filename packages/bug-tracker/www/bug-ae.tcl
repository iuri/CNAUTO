ad_page_contract {
    Bug add page.
    
    @author Lars Pind (lars@pinds.com)
    @creation-date 2002-03-25
    @cvs-id $Id: bug-add.tcl,v 1.14.2.1 2005/11/26 13:10:58 roelc Exp $
} {
    bug_id:optional
    file_id:optional
    {return_url ""}
}

if { [empty_string_p $return_url] } {
    set return_url "."
}

ad_require_permission [ad_conn package_id] create

# User needs to be logged in here
auth::require_login

# Set some common bug-tracker variables
set project_name [bug_tracker::conn project_name]
set package_id [ad_conn package_id]
set package_key [ad_conn package_key]

set Bug_name [bug_tracker::conn Bug]
set page_title [_ bug-tracker.New_1]

set workflow_id [bug_tracker::bug::get_instance_workflow_id]

set context [list $page_title]

set user_id [ad_conn user_id]

# Is this project using multiple versions?
set versions_p [bug_tracker::versions_p]


if {![info exists bug_id]} {
    set file_id [db_nextval acs_object_id_seq]
}


# Create the form
ad_form -name bug -cancel_url $return_url -action bug-ae -form {
    bug_id:key(acs_object_id_seq)
    {component_id:text(select) 
        {label "[bug_tracker::conn Component]"} 
	{options {[bug_tracker::components_get_options]}} 
	{value {[bug_tracker::conn component_id]}}
    }
    {found_in_version:text(select),optional 
        {label "[_ bug-tracker.Version]"}  
        {options {[bug_tracker::version_get_options -include_unknown]}} 
        {value {[bug_tracker::conn user_version_id]}}
    }
    {fix_for_version:text(select),optional 
        {label "Fix For Version"}  
        {options {[bug_tracker::version_get_options -include_unknown]}} 
        {value {[bug_tracker::conn user_version_id]}}
    }

    {assign_to:text(select),optional 
        {label "[_ bug-tracker.Assign_to]"}  
        {options {[bug_tracker::assignee_get_options -workflow_id $workflow_id -include_unknown]}} 
    }

    {return_url:text(hidden) {value $return_url}}
}
foreach {category_id category_name} [bug_tracker::category_types] {
    ad_form -extend -name bug -form [list \
        [list "${category_id}:integer(select)" \
            [list label $category_name] \
            [list options [bug_tracker::category_get_options -parent_id $category_id]] \
            [list value   [bug_tracker::get_default_keyword -parent_id $category_id]] \
        ] \
    ]
}


ad_form -extend -name bug  -form {
    {description:richtext(richtext),optional
        {label "[_ bug-tracker.Description]"}
        {html {cols 60 rows 13}}
    }
    {attach_file:text(inform)
	{label ""}
	{value {
	    <div id="mainbody" >
	    <div id="upload" >
	    <span>Upload File<span></div><span id="status" ></span>
	    <ul id="files" ></ul>
	    <input type="hidden" name="file_id" id="file_id" value="$file_id">
	}}
    }   
    
} -edit_request {
} -new_data {
    
    set keyword_ids [list]
    foreach {category_id category_name} [bug_tracker::category_types] {
        # -singular not required here since it's a new bug
        lappend keyword_ids [element get_value bug $category_id]
    }
    
    bug_tracker::bug::new \
	-bug_id $bug_id \
	-package_id $package_id \
	-component_id $component_id \
	-found_in_version $found_in_version \
	-summary $bug_id \
	-description [template::util::richtext::get_property contents $description] \
	-desc_format [template::util::richtext::get_property format $description] \
        -keyword_ids $keyword_ids \
	-fix_for_version $fix_for_version \
	-assign_to $assign_to
    
    db_foreach uploadfile_id {
	SELECT item_id, name FROM cr_items WHERE parent_id = :package_id
    } {
	set filename [lindex [split $name "-"] 0] 
	set filename_id [lindex [split $name "-"] 1]

	if {$filename_id == $file_id} {
	    db_dml update_parent_id {
		UPDATE cr_items SET parent_id = :bug_id WHERE item_id = :item_id;
	    }
	}
    }
    


} -after_submit {
    bug_tracker::bugs_exist_p_set_true
    
    ad_returnredirect $return_url
    ad_script_abort
    
}

if { !$versions_p } {
    element set_properties bug found_in_version -widget hidden
    element set_properties bug fix_for_version -widget hidden
}

 
template::head::add_css -href "/resources/bug-tracker/styles.css"

template::head::add_javascript -src "/resources/bug-tracker/js/jquery-1.3.2.js" -order 0
template::head::add_javascript -src "/resources/bug-tracker/js/ajaxupload.3.5.js" -order 1

# References http://valums.com/ajax-upload/
template::head::add_javascript -script {
    $(function(){
	var btnUpload=$('#upload');
	var status=$('#status');
	var fileId = $('#file_id').val();
	
	new AjaxUpload(btnUpload, {
	    action: 'file-add',
	    data: { file_id: $('#file_id').val()},
	    name: 'uploadfile',
	    onSubmit: function(file, ext){
		if (! (ext && /^(jpg|png|jpeg|gif)$/.test(ext))){ 
                    // extension is not allowed 
		    status.text('Only JPG, PNG or GIF files are allowed');
		    return false;
		}
		status.text('Uploading...');
	    },
	    onComplete: function(file, response){
		//On completion clear the status
		status.text('');
		//Add uploaded file to list
		if(response==="success"){
		    $('<li></li>').appendTo('#files').html('<img src="./uploads/'+file+'" alt="" /><br />'+file).addClass('success');
		} else{
		    $('<li></li>').appendTo('#files').text(file).addClass('error');
		}
	    }
	});
	
    });
} -order 2

ad_return_template
