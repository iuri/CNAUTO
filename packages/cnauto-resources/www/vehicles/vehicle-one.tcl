ad_page_contract {
    Shows person's info
} {
    {vehicle_id:integer,optional}
    {return_url ""}
}

set page_title [_ cnauto-resources.Vehicle_info]

ns_log Notice "$return_url"

ad_form -name vehicle_one -action vehicle-ae -export {return_url vehicle_id} -has_submit 1 -has_edit 1 -mode display -form {
    {inform1:text(inform)
        {label "<h2>[_ cnauto-resources.Vehicle_info]</h2>"}
    }
    {vin:text(text)
	{label "[_ cnauto-resources.Chassis]"}
    }
    {resource:text(text)
	{label "[_ cnauto-resources.Resource]"}
    }
    {engine:text(text)
	{label "[_ cnauto-resources.Engine]"}
    }
    {color:text(text)
	{label "[_ cnauto-resources.Color]"}
    }
    {year_of_model:text(text)
	{label "[_ cnauto-resources.YoM]"}
    } 
    {year_of_fabrication:text(text)
	{label "[_ cnauto-resources.YoF]"}
    } 
    {owner:text(text)
	{label "[_ cnauto-resources.Owner]"}
    } 
    {distributor:text(text)
	{label "[_ cnauto-resources.Distributor]"}
    } 
    {purchase_date:text,optional
	{label "[_ cnauto-resources.Purchase_date]"}
	{format "YYY MM DD"}
    }
    {arrival_date:text,optional
	{label "[_ cnauto-resources.Arrival_date]"}
	{format "YYY MM DD"}
    }
    {billing_date:text,optional
	{label "[_ cnauto-resources.Billing_date]"}
	{format "YYY MM DD"}
    }
    {notes:text(text)
	{label "[_ cnauto-resources.Notes]"}
    } 
}

ad_form -extend -name vehicle_one -on_request {
    
   
    db_1row select_vehicle_info {
	
	SELECT cv.vin, cr.pretty_name AS resource, cv.engine, cv.year_of_model, cv.year_of_fabrication, cp.pretty_name AS owner, cp2.pretty_name AS distributor, cv.purchase_date, cv.arrival_date, cv.billing_date  
	FROM cn_vehicles cv
	LEFT OUTER JOIN cn_resources cr ON (cr.resource_id = cv.resource_id)
	LEFT OUTER JOIN cn_persons cp ON (cp.person_id = cv.owner_id)
	LEFT OUTER JOIN cn_persons cp2 ON (cp2.person_id = cv.distributor_id)
	WHERE cv.vehicle_id = :vehicle_id
    }
    
    
    
    
    set vehicle_ae_url [export_vars -base "vehicle-ae" {vehicle_id return_url}]
    
} -on_submit {
    
    set myform [ns_getform]
    if {[string equal "" $myform]} {
	ns_log Notice "No Form was submited"
    } else {
	ns_log Notice "FORM"
	ns_set print $myform
    }
}




