ad_page_contract {
    
    Add/Edit Assurance Requirement

} {
    {assurance_id:integer,optional}
    {return_url ""}
}


if { [exists_and_not_null assurance_id] } {
    set page_title [_ cnauto-assurance.Edit_assurance]
    #set ad_form_mode display
} else {
    set page_title [_ cnauto-assurance.Add_assurance]
    #set ad_form_mode edit
}


set return_url [ad_return_url]
set vehicle_ae_url [export_vars -base "vehicle-ae" {return_url}] 
set person_ae_url [export_vars -base "person-ae" {return_url}] 


ad_form -name assurance_ae -form {
    {assurance_id:key}
    {inform1:text(inform)
        {label "<h2>[_ cnauto-assurance.Vehicle_info]</h2>"}
        {value ""}
    }
    {dcn:integer
	{label "[_ cnauto-assurance.DCN]"}
	{html {size 5} maxlength 10}
	{value ""}
    }
    {assurance_number:integer
	{label "[_ cnauto-assurance.Number]"}
	{value ""}
    }
    {assurance_date:date
	{label "[_ cnauto-assurance.Assurance_date]"}
	{format "YYYY MM DD"}
	{after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('assurance_date', 'y-m-d');" > \[<b>[_ calendar.y-m-d]</b>\]}} 
    }
    {status:text(text)
	{label "[_ cnauto-assurance.Status]"}
        {value ""}
    }
    {lp:text(text)
	{label "[_ cnauto-assurance.LP]"}
        {value ""}
    }
    {lp_date:date
	{label "[_ cnauto-assurance.LP_date]"}
	{format "YYYY MM DD"}
	{after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('lp_date', 'y-m-d');" > \[<b>[_ calendar.y-m-d]</b>\]}} 
    }
    {lp_2:text(text)
	{label "[_ cnauto-assurance.LP_2]"}
        {value ""}
    }
    {lp_2_date:date
	{label "[_ cnauto-assurance.LP_2_date]"}
	{format "YYYY MM DD"}
	{after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('lp_2_date', 'y-m-d');" > \[<b>[_ calendar.y-m-d]</b>\]}} 
    }
    {service_order:integer 
	{label "[_ cnauto-assurance.Service_order]"}
	{html {size 5} maxlength 10}
        {value ""}
    }
    {so_date:date
	{label "[_ cnauto-assurance.SO_date]"}
	{format "YYYY MM DD"}
	{after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('so_date', 'y-m-d');" > \[<b>[_ calendar.y-m-d]</b>\]}}
	
    }
    {chassis:text(text)
	{label "[_ cnauto-assurance.Chassis]"}
	{help_text "<a href=\"${vehicle_ae_url}\">#cnauto-assurance.Add_vehicle#</a>"}
        {value ""}
    }
    {kilometers:integer
	{label "[_ cnauto-assurance.Kilometers]"}
	{html {size 10} maxlength 10}
        {value ""}
    }
    {part_group:text(text)
	{label "[_ cnauto-assurance.Set]"}
	{html {size 10} maxlength 10}
        {value ""}
    }
    {part_code:text(text)
	{label "[_ cnauto-assurance.Part_code]"}
        {value ""}
    }
    {part_quantity:integer
	{label "[_ cnauto-assurance.Quantity]"}
	{html {size 5} maxlength 10}
        {value ""}
    }
    {damage_description:text(textarea)
	{label "[_ cnauto-assurance.Damage]"}
        {value ""}
    }
    {third_service:text(text)
	{label "[_ cnauto-assurance.Third_service]"}
        {value ""}
    }
    {cost_price:text(text)
	{label "[_ cnauto-assurance.Cost_price]"}
        {value ""}
    }
    {assurance_price:text(text)
	{label "[_ cnauto-assurance.LP_date]"}
        {value ""}
    }
    {tmo_code:text(text)
	{label "[_ cnauto-assurance.LP_date]"}
        {value ""}
    }
    {tmo_duration:text(text)
	{label "[_ cnauto-assurance.LP_date]"}
        {value ""}
    }
    {cost:text(text)
	{label "[_ cnauto-assurance.LP_date]"}
        {value ""}
    }
    {ttl_sg:text(text)
	{label "[_ cnauto-assurance.LP_date]"}
        {value ""}
    }
} -on_submit {
} -new_data {
    
    set assurance_date "[template::util::date::get_property year $assurance_date] [template::util::date::get_property month $assurance_date] [template::util::date::get_property day $assurance_date]"

    set lp_date "[template::util::date::get_property year $lp_date] [template::util::date::get_property month $lp_date] [template::util::date::get_property day $lp_date]"

    set lp_2_date "[template::util::date::get_property year $lp_2_date] [template::util::date::get_property month $lp_2_date] [template::util::date::get_property day $lp_2_date]"


    set so_date "[template::util::date::get_property year $so_date] [template::util::date::get_property month $so_date] [template::util::date::get_property day $so_date]"


    db_transaction { 
	set assurance_id [cn_assurance::new \
			      -dcn $dcn \
			      -assurance_number $assurance_number \
			      -assurance_date $assurance_date \
			      -status $status \
			      -lp $lp \
			      -lp_date $lp_date \
			      -lp_2 $lp_2 \
			      -lp_2_date $lp_2_date \
			      -service_order $service_order \
			      -service_order_date $so_date \
			      -chassis $chassis \
			      -kilometers $kilometers \
			      -part_group $part_group \
			      -part_code $part_code \
			      -part_quantity $part_quantity \
			      -damage_description $damage_description \
			      -third_service $third_service \
			      -cost_price $cost_price \
			      -assurance_price $assurance_price \
			      -tmo_code $tmo_code \
			      -tmo_duration $tmo_duration \
			      -cost  $cost \
			      -ttl_sg $ttl_sg \
			      -creation_ip [ad_conn peeraddr] \
			      -creation_user [ad_conn user_id] \
			      -context_id [ad_conn package_id] \
			 ]
    }
    
    
} -edit_data {
} -after_submit {
    ad_returnredirect $return_url
    ad_script_abort
}



