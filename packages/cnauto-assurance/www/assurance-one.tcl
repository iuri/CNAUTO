ad_page_contract {
    Assurance Detailed Info
} {
    assurance_id
    {return_url ""}
    
}

set page_title [_ cnauto-assurance.Assurance_info]

set vehicle_id [db_string select_vehicle_id { SELECT vehicle_id FROM cn_assurances WHERE assurance_id = :assurance_id }]
set vehicle_one_url [export_vars -base "vehicle-one" {return_url vehicle_id}] 


ad_form -name assurance -mode display -form {
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
	{help_text "<a href=\"${vehicle_one_url}\">#cnauto-assurance.Vehicle_details#</a>"}
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
} -on_request {
    
    db_1row select_assurance_info {
	SELECT ca.dcn, ca.assurance_number, ca.assurance_date, ca.status, ca.lp, ca.lp_date, ca.lp_2, ca.lp_2_date, ca.service_order, ca.service_order_date AS so_date, ca.vehicle_id, cv.vin AS chassis, ca.kilometers, ca.part_group, ca.part_code, ca.part_quantity, ca.damage_description, ca.third_service, ca.cost_price, ca.assurance_price, ca.tmo_code, ca.tmo_duration, ca.cost, ca.ttl_sg
	FROM cn_assurances ca, cn_vehicles cv
	WHERE cv.vehicle_id = ca.vehicle_id 
	AND ca.assurance_id = :assurance_id
    }
}
