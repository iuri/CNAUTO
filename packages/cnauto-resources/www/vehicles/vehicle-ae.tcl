ad_page_contract {    
    Add/Edit Vehicle
} {    
    {vehicle_id:integer,optional}    
    {return_url ""}
}

if { [exists_and_not_null vehicle_id] } {
    set page_title [_ cnauto-resources.Edit_vehicle]    
    #set ad_form_mode display
} else {    
    set page_title [_ cnauto-resources.Add_vehicle]    
    #set ad_form_mode edit
}


set color_options [cn_resources::vehicles::get_color_options]
set year_options {"Selecione 0" "2000 2000" "2001 2001" "2002 2002" "2003 2003" "2004 2004" "2005 2005" "2006 2006" "2007 2007" "2008 2008" "2009 2009" "2010 2010" "2011 2011"}

#set year_options [db_list_of_lists select_years { SELECT EXTRACT(YEAR FROM INTERVAL ('now' + '10 years')); }]

set owner_options [cn_resources::vehicles::get_owner_options]

set distributor_options [cn_resources::vehicles::get_distributor_options]


set vehicle_type_id [cn_categories::get_category_id -name "veiculos" -type "cn_resource"] 
set resource_options [db_list_of_lists select_resources {
    SELECT cr.pretty_name, cr.resource_id FROM cn_resources cr WHERE cr.type_id = :vehicle_type_id
}]

lappend resource_options {"Selecione" ""}

set person_ae_url [export_vars -base "person-ae" {return_url}] 

ad_form -name vehicle_ae -form {
    {vehicle_id:key}
    {inform1:text(inform)
        {label "<h2>[_ cnauto-resources.Vehicle_info]</h2>"}
        {value ""}
    }
    {vin:text(text)
	{label "[_ cnauto-resources.Chassis]"}
    }    
    {resource_id:integer(select)
	{label "[_ cnauto-resources.Resource]"}
	{options $resource_options} 
    }	
    {engine:text(text)
	{label "[_ cnauto-resources.Engine]"}
    }
    {color:text(select),optional
	{label "[_ cnauto-resources.Color]"}
	{options $color_options}
    }
    {year_of_model:integer(select),optional
	{label "[_ cnauto-resources.Year_of_model]"}
	{options $year_options} 
    }
    {year_of_fabrication:integer(select),optional
	{label "[_ cnauto-resources.Year_of_fabricant]"}
	{options $year_options}   
    }
    {purchase_date:date,optional,optional
	{label "[_ cnauto-resources.Purchase_date]"}
	{format "YYYY MM DD"}
	{help_text "[_ cnauto-resources.y-m-d]"}
	{after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('purchase_date', 'y-m-d');" >}}   
    }   
    {arrival_date:date,optional
	{label "[_ cnauto-resources.Arrival_date]"}
	{format "YYYY MM DD"}
	{help_text "[_ cnauto-resources.y-m-d]"}
	{after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('arrival_date', 'y-m-d');" >} }
    }
    {billing_date:date,optional
	{label "[_ cnauto-resources.Billing_date]"}
	{format "YYYY MM DD"}
	{help_text "[_ cnauto-resources.y-m-d]"}
	{after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('billing_date', 'y-m-d');" >} }
    }
    {warranty_time:text(text),optional
	{label "[_ cnauto-resources.Warranty_time]"}
    }
    {distributor_id:integer(select),optional
	{label "[_ cnauto-resources.Distributor]"}
	{options $distributor_options}
	{help_text "<a href=\"${person_ae_url}\">#cnauto-resources.Add_distributor#</a>"}
    }
    {inform3:text(inform)
        {label "<h2>[_ cnauto-resources.Client_info]</h2>"}
        {value ""} 
    }
    {owner_id:integer(select),optional
	{label "[_ cnauto-resources.Owner]"}
	{options $owner_options}
	{help_text "<a href=\"${person_ae_url}\">#cnauto-resources.Add_owner#</a>"}
    }
    {notes:text(textarea),optional
	{label "[_ cnauto-resources.Notes]"}
    }
    {return_url:text(hidden)
	{value $return_url}
    }
} -on_submit {
} -edit_request {
    
    db_1row select_vehicle_info {
	SELECT cv.vin, cv.resource_id, cv.engine, cv.year_of_model, cv.year_of_fabrication, cv.warranty_time, cv.owner_id, cv.distributor_id, cv.purchase_date, cv.arrival_date, cv.billing_date, cv.notes
	FROM cn_vehicles cv
	WHERE cv.vehicle_id = :vehicle_id
    }


    set purchase_date [template::util::date::from_ansi $purchase_date [lc_get formbuilder_time_format]]
    set arrival_date [template::util::date::from_ansi $arrival_date [lc_get formbuilder_time_format]]
    set billing_date [template::util::date::from_ansi $billing_date [lc_get formbuilder_time_format]]
   


} -edit_data {

    set vin [string trim $vin]

    set arrival_date "[template::util::date::get_property year $arrival_date] [template::util::date::get_property month $arrival_date] [template::util::date::get_property day $arrival_date]"
    set billing_date "[template::util::date::get_property year $billing_date] [template::util::date::get_property month $billing_date] [template::util::date::get_property day $billing_date]"
    set purchase_date "[template::util::date::get_property year $purchase_date] [template::util::date::get_property month $purchase_date] [template::util::date::get_property day $purchase_date]"

    cn_resources::vehicle::edit \
	-vehicle_id $vehicle_id \
	-vin $vin \
	-engine $engine \
	-year_of_model $year_of_model \
	-year_of_fabrication $year_of_fabrication \
	-color $color \
	-purchase_date $purchase_date \
	-arrival_date $arrival_date \
	-billing_date $billing_date \
	-warranty_time $warranty_time \
	-distributor_id $distributor_id \
	-owner_id $owner_id \
	-resource_id $resource_id \
	-notes $notes 




} -new_data { 

    set vehicle_exists_p [db_0or1row select_vehicle_id {
	SELECT vehicle_id FROM cn_vehicles WHERE vin = :vin
    }]

    if {$vehicle_exists_p} {
	ad_return_complaint 1 "The chassis already exists on the database! Please <a href=\"javascript:history.go(-1);\">go back and fix it!</a> "
    } else {
			  
	set vin [string trim $vin]

	if {$arrival_date ne ""} {
	    set arrival_date "[template::util::date::get_property year $arrival_date] [template::util::date::get_property month $arrival_date] [template::util::date::get_property day $arrival_date]"
	}
	if {$billing_date ne ""} {
	    set billing_date "[template::util::date::get_property year $billing_date] [template::util::date::get_property month $billing_date] [template::util::date::get_property day $billing_date]"
	}
	if {$purchase_date ne ""} {
	    set purchase_date "[template::util::date::get_property year $purchase_date] [template::util::date::get_property month $purchase_date] [template::util::date::get_property day $purchase_date]"
	}
	
	
	cn_resources::vehicle::new \
	    -vin $vin \
	    -engine $engine \
	    -year_of_model $year_of_model \
	    -year_of_fabrication $year_of_fabrication \
	    -color $color \
	    -purchase_date $purchase_date \
	    -arrival_date $arrival_date \
	    -billing_date $billing_date \
	    -warranty_time $warranty_time \
	    -distributor_id $distributor_id \
	    -owner_id $owner_id \
	    -resource_id $resource_id \
	    -notes $notes \
	    -creation_ip [ad_conn peeraddr] \
	    -creation_user [ad_conn user_id] \
	    -context_id [ad_conn package_id]
    }
	
} -after_submit {
    ad_returnredirect $return_url
    ad_script_abort
} 
