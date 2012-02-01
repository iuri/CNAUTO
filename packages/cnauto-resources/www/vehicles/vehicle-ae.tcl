ad_page_contract {    
    Add/Edit Vehicle
} {    
    {vehicle_id:integer,optional}    
    {return_url ""}
}

if { [exists_and_not_null vehicle_id] } {
    set page_title [_ cnauto-assurance.Edit_vehicle]    
    #set ad_form_mode display
} else {    
    set page_title [_ cnauto-assurance.Add_vehicle]    
    #set ad_form_mode edit
}

set color_options [cn_assurance::get_color_options]
set year_options {"2000 2000" "2001 2001" "2002 2002" "2003 2003" "2004 2004" "2005 2005" "2006 2006" "2007 2007" "2008 2008" "2009 2009" "2010 2010" "2011 2011"}

#set year_options [db_list_of_lists select_years { SELECT EXTRACT(YEAR FROM INTERVAL ('now' + '10 years')); }]

set client_options [db_list_of_lists select_clients {
    SELECT cp.pretty_name, cp.person_id 
    FROM cn_persons cp, cn_categories cc
    WHERE cp.type_id = cc.category_id AND cc.name = 'clientes'
}]


set distributor_options [db_list_of_lists select_clients {
    SELECT cp.pretty_name, cp.person_id 
    FROM cn_persons cp, cn_categories cc
    WHERE cp.type_id = cc.category_id AND cc.name = 'concessionarias'
}]

set chassis_options [db_list_of_lists select_chassis {
    SELECT vin, vehicle_id FROM cn_vehicles LIMIT 20
}]


set resource_options [db_list_of_lists select_resources {
    SELECT pretty_name, resource_id FROM cn_resources WHERE class = 'vehicles'
}]


set return_url [ad_return_url]
set person_ae_url [export_vars -base "person-ae" {return_url}] 

ad_form -name vehicle_ae -form {
    {vehicle_id:key}
    {inform1:text(inform)
        {label "<h2>[_ cnauto-assurance.Vehicle_info]</h2>"}
        {value ""}
    }
    {chassis:text(text)
	{label "[_ cnauto-asssurance.Chassis]"}
    }    
    {model:text(text)
	{label "[_ cnauto-asssurance.Model]"}
    }    
    {resource_id:integer(select)
	{label "[_ cnauto-assurance.Resource]"}
	{options $resource_options} 
    }	
    {engine:text(text)
	{label "[_ cnauto-assurance.Engine]"}
    }
    {color:text(select)
	{label "[_ cnauto-assurance.Color]"}
	{options $color_options}
    }
    {year_of_model:integer(select)
	{label "[_ cnauto-assurance.Year_of_model]"}
	{options $year_options} 
    }
    {year_of_fabrication:integer(select)
	{label "[_ cnauto-assurance.Year_of_fabricant]"}
	{options $year_options}   
    }
    {purchase_date:date
	{label "[_ cnauto-assurance.Purchase_date]"}
	{format "YYYY MM DD"}
	{after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('purchase_date', 'y-m-d');" > \[<b>[_ calendar.y-m-d]</b>\]}}   
    }   
    {arrival_date:date
	{label "[_ cnauto-assurance.Arrival_date]"}
	{format "YYYY MM DD"}
	{after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('arrival_date', 'y-m-d');" > \[<b>[_ calendar.y-m-d]</b>\]} }
    }
    {billing_date:date
	{label "[_ cnauto-assurance.Billing_date]"}
	{format "YYYY MM DD"}
	{after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('billing_date', 'y-m-d');" > \[<b>[_ calendar.y-m-d]</b>\]} }
    }
    {duration:text(text)
	{label "[_ cnauto-assurance.Duration]"}
    }
    {distributor_id:text(select)
	{label "[_ cnauto-assurance.Distributor]"}
	{options $distributor_options}
	{help_text "<a href=\"${person_ae_url}\">#cnauto-assurance.Add_distributor#</a>"}
    }
    {inform3:text(inform)
        {label "<h2>[_ cnauto-assurance.Client_info]</h2>"}
        {value ""} 
    }
    {client_id:integer(select)
	{label "[_ cnauto-assurance.Client]"}
	{options $client_options}
	{help_text "<a href=\"${person_ae_url}\">#cnauto-assurance.Add_client#</a>"}
    }
    {notes:text(textarea)
	{label "[_ cnauto-assurance.Notes]"}
    }
} -on_submit {
} -new_data { 
    set arrival_date "[template::util::date::get_property year $arrival_date] [template::util::date::get_property month $arrival_date] [template::util::date::get_property day $arrival_date]"
    set billing_date "[template::util::date::get_property year $billing_date] [template::util::date::get_property month $billing_date] [template::util::date::get_property day $billing_date]"
    set purchase_date "[template::util::date::get_property year $purchase_date] [template::util::date::get_property month $purchase_date] [template::util::date::get_property day $purchase_date]"

    db_transaction {
	cn_vehicle::new \
	    -chassis $chassis \
	    -model $model \
	    -engine $engine \
	    -year_of_model $year_of_model \
	    -year_of_fabrication $year_of_fabrication \
	    -color $color \
	    -arrival_date $arrival_date \
	    -billing_date $billing_date \
	    -purchase_date $purchase_date \
	    -duration $duration \
	    -distributor_id $distributor_id \
	    -client_id $client_id \
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
