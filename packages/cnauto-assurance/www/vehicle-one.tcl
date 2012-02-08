ad_page_contract {
    Add/Edit Vehicle
} {
    {vehicle_id:integer,optional}
    {return_url ""}
}

set page_title [_ cnauto-assurance.Vehicle_info]

set return_url [ad_return_url]

set person_id [db_string select_person_id { SELECT person_id FROM cn_vehicles WHERE vehicle_id = :vehicle_id }]

set person_one_url [export_vars -base "person-one" {person_id return_url}]


ad_form -name vehicle_one -action vehicle-ae -export_vars {return_url vehicle_id} -mode display -form {
    {inform1:text(inform)
        {label "<h2>[_ cnauto-assurance.Vehicle_info]</h2>"}
        {value ""}
    }
    {vin:text(text)
	{label "[_ cnauto-asssurance.Chassis]"}
    }
    {model:text(text)
	{label "[_ cnauto-asssurance.Model]"}
    }
    {engine:text(text)
	{label "[_ cnauto-assurance.Engine]"}
    }	
    {color:text(text)
	{label "[_ cnauto-assurance.Color]"}
    }
    {year_of_model:integer(text)
	{label "[_ cnauto-assurance.Year_of_model]"}
    } 
    {year_of_fabrication:integer(text)
	{label "[_ cnauto-assurance.Year_of_fabricant]"}
    } 
    {purchase_date:date
	{label "[_ cnauto-assurance.Purchase_date]"}
	{format "YYYY MM DD"}
	{after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('purchase_date', 'y-m-d');" > \[<b>[_ calendar.y-m-d]</b>\]} 
	} 
    }
    {arrival_date:date
	{label "[_ cnauto-assurance.Arrival_date]"}
	{format "YYYY MM DD"}
	{after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('arrival_date', 'y-m-d');" > \[<b>[_ calendar.y-m-d]</b>\]} 
	} 
    }
    {billing_date:date
	{label "[_ cnauto-assurance.Billing_date]"}
	{format "YYYY MM DD"}
	{after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('billing_date', 'y-m-d');" > \[<b>[_ calendar.y-m-d]</b>\]} 
	} 
    }
    {duration:text(text)
	{label "[_ cnauto-assurance.Duration]"}
    }
    {distributor_code:text(text)
	{label "[_ cnauto-assurance.Distributor]"}
    }
    {inform3:text(inform)
        {label "<h2>[_ cnauto-assurance.Client_info]</h2>"}
        {value ""}
    }
    {person_name:text(text)
	{label "[_ cnauto-assurance.Client]"}
    }
    {notes:text(textarea)
	{label "[_ cnauto-assurance.Notes]"}
    }
} -on_request {

    db_1row select_vehicle_info {
	
	SELECT DISTINCT cv.vin, cv.model, cv.engine, cc.name AS color, cv.year_of_model, cv.year_of_fabrication, cv.purchase_date, cv.arrival_date, cv.billing_date, cv.duration, cv.distributor_code, cv.person_id, cp.first_names || ' ' || cp.last_name AS person_name, cv.notes FROM cn_vehicles cv, cn_persons cp, cn_colors cc WHERE cv.person_id = cp.person_id AND cv.color = cc.code AND cv.vehicle_id = :vehicle_id;
	
    }
}