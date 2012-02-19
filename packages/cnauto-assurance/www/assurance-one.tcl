ad_page_contract {
    Assurance Detailed Info
} {
    assurance_id
    {return_url ""}
    
}

set page_title [_ cnauto-assurance.Assurance_info]

set vehicle_id [db_string select_vehicle_id { SELECT vehicle_id FROM cn_assurances WHERE assurance_id = :assurance_id }]
set vehicle_one_url [export_vars -base "vehicle-one" {return_url vehicle_id}] 

set assurance_ae_url [export_vars -base "assurance-ae" {return_url assurance_id}]
 
ad_form -name assurance -mode display -has_edit 1  -form {
    {inform1:text(inform)
        {label "<h2>[_ cnauto-assurance.Vehicle_info]</h2>"}
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
    {parts_total_cost:text
	{label "[_ cnauto-assurance.Total_portals]"}
    }
    {assurance_total_cost:text
	{label "[_ cnauto-assurance.Total_assurance]"}
    }
    {third_total_cost:text
	{label "[_ cnauto-assurance.Total_third]"}
    }
    {mo_total_cost:text
	{label "[_ cnauto-assurance.Total_MO]"}
    }
    {total_cost:text
	{label "[_ cnauto-assurance.Total]"}
    }
    {description:text(textarea)
	{label "[_ cnauto-assurance.Description]"}
	{html {rows 50 cols 100}}
    }

} -on_request {
    
    db_1row select_assurance_info {
	SELECT ca.assurance_number, ca.assurance_date, ca.status, ca.service_order, ca.service_order_date AS so_date, ca.vehicle_id, cv.vin AS chassis, ca.kilometers
	FROM cn_assurances ca, cn_vehicles cv
	WHERE cv.vehicle_id = ca.vehicle_id 
	AND ca.assurance_id = :assurance_id
    }


   # set assurance_date [template::util::date::from_ansi $assurance_date [lc_get formbuilder_time_format]]

    #set service_order_date [template::util::date::from_ansi $so_date [lc_get formbuilder_time_format]]
}

template::list::create \
    -name parts \
    -multirow parts \
    -elements {
	code {
	    label "[_ cnauto-assurance.Code]"
	}
	name {
	    label "[_ cnauto-assurance.Name]"
	}
	cost {
	    label "[_ cnauto-assurance.Cost]"
	}
	assurance_cost {
	    label "[_ cnauto-assurance.Assurance_cost]"
	}
	quantity {
	    label "[_ cnauto-assurance.Quantity]"
	}
	incomes {
	    label "[_ cnauto-assurance.Incomes]"
	}
	mo_code {
	    label "[_ cnauto-assurance.MO_code]"
	}
	mo_time {
	    label "[_ cnauto-assurance.MO_time]"
	}
	third_services_cost {
	    label "[_ cnauto-assurance.Third_services_cost]"
	}
    }

db_multirow -extend {} parts select_parts {
    SELECT cp.code, cp.name, apr.cost, apr.quantity, apr.assurance_cost, apr.incomes, apr.mo_code, apr.mo_time, apr.third_services_cost
    FROM cn_assurance_part_requests apr, cn_parts cp
    WHERE apr.assurance_id = :assurance_id
    AND apr.part_id = cp.part_id 
}