ad_page_contract {
    Assurance Detailed Info
} {
    assurance_id
    {return_url ""}
    
}

set page_title [_ cnauto-assurance.Assurance_info]


set resources_url "/cnauto/cnauto-resources"

set vehicle_id [db_string select_vehicle_id { SELECT vehicle_id FROM cn_assurances WHERE assurance_id = :assurance_id } -default null]
set vehicle_one_url [export_vars -base "${resources_url}/vehicles/vehicle-one" {return_url vehicle_id}] 

set person_id [db_string select_vehicle_id { SELECT distributor_id FROM cn_assurances WHERE assurance_id = :assurance_id }]
set distributor_one_url [export_vars -base "${resources_url}/persons/person-one" {return_url person_id {type_id 272111}}] 

set person_id [db_string select_vehicle_id { SELECT owner_id FROM cn_assurances WHERE assurance_id = :assurance_id }]
set owner_one_url [export_vars -base "${resources_url}/persons/person-one" {return_url person_id {type_id 272235}}] 


set assurance_ae_url [export_vars -base "assurance-ae" {return_url assurance_id}]
 
ad_form -name assurance -mode display -has_edit 1  -form {
    {inform1:text(inform)
        {label "<h2>[_ cnauto-assurance.Assurance_info]</h2>"}
        {value ""}
    }
    {assurance_number:integer
	{label "[_ cnauto-assurance.Number]"}
	{value ""}
    }
    {assurance_date:date
	{label "[_ cnauto-assurance.Assurance_date]"}
	{format "YYYY MM DD"}
	{after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('assurance_date', 'y-m-d');" > \[<b>[_ cnauto-assurance.y-m-d]</b>\]}} 
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
	{after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('so_date', 'y-m-d');" > \[<b>[_ cnauto-assurance.y-m-d]</b>\]}}
	
    }
    {chassis:text(text)
	{label "[_ cnauto-assurance.Chassis]"}
	{help_text "<a href=\"${vehicle_one_url}\">#cnauto-assurance.Vehicle_details#</a>"}
    }
    {kilometers:integer
	{label "[_ cnauto-assurance.Kilometers]"}
	{html {size 10} maxlength 10}
        {value ""}
    }
    {distributor_name:text
	{label "[_ cnauto-assurance.Distributor]"}
	{help_text "<a href=\"${distributor_one_url}\">#cnauto-assurance.Distributor_details#</a>"}
    }
    {owner_name:text
	{label "[_ cnauto-assurance.Owner]"}
	{help_text "<a href=\"${owner_one_url}\">#cnauto-assurance.Owner_details#</a>"}
    }
    {parts_total_cost:text
	{label "[_ cnauto-assurance.Parts_total]"}
    }
    {assurance_total_cost:text
	{label "[_ cnauto-assurance.Assurance_total]"}
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
	SELECT ca.assurance_number, ca.assurance_date, ca.status, ca.service_order, ca.service_order_date AS so_date, ca.vehicle_id, cv.vin AS chassis, ca.kilometers, parts_total_cost, assurance_total_cost, third_total_cost, mo_total_cost, total_cost, description, cp1.person_id AS owner_id, cp1.pretty_name AS owner_name, cp2.person_id AS distributor_id, cp2.pretty_name AS distributor_name 
	FROM cn_assurances ca
	LEFT OUTER JOIN cn_persons cp1 ON (cp1.person_id = ca.owner_id)
	LEFT OUTER JOIN cn_persons cp2 ON (cp2.person_id = ca.distributor_id)
	LEFT OUTER JOIN cn_vehicles cv ON (cv.vehicle_id = ca.vehicle_id)
	WHERE ca.assurance_id = :assurance_id
    }

    
    set workflow_html [cn_assurance::workflow_cicle_html -status $status]


   # set assurance_date [template::util::date::from_ansi $assurance_date [lc_get formbuilder_time_format]]

    #set service_order_date [template::util::date::from_ansi $so_date [lc_get formbuilder_time_format]]
}

set actions [list]

set admin_p [permission::permission_p -object_id [ad_conn package_id] -party_id [ad_conn user_id] -privilege "admin"]

if {$admin_p} {
    set url [ad_conn url]

    set assurance_ae2_url [export_vars -base "assurance-ae-2" {return_url assurance_id}]


    set close_assurance_url [export_vars -base "change-assurance-status" {{return_url $url} assurance_id {status closed}}]

    if {$status == "unapproved"} {
	set approve_assurance_url [export_vars -base "change-assurance-status" {assurance_id {return_url $url} {status approved}}]


	set actions [list \
			 "[_ cnauto-assurance.Add]" $assurance_ae2_url "[_ cnauto-assurance.Add]" \
			 "[_ cnauto-assurance.Edit]" $assurance_ae_url "[_ cnauto-assurance.Edit_assurance]" \
			 "[_ cnauto-assurance.Approve]" $approve_assurance_url "[_ cnauto-assurance.Approve_assurance]" \
			 "[_ cnauto-assurance.Close]" $close_assurance_url "[_ cnauto-assurance.Close_assurance]" \
			 "[_ cnauto-assurance.Cancel]" $return_url "[_ cnauto-assurance.Cancel]" \
			]
	
	
    } elseif {$status == "approved"} {
	set disapprove_assurance_url [export_vars -base "change-assurance-status" {assurance_id {return_url $url} {status unapproved}}]
	
	set actions [list \
			 "[_ cnauto-assurance.Add]" $assurance_ae2_url "[_ cnauto-assurance.Add]" \
			 "[_ cnauto-assurance.Edit]" $assurance_ae_url "[_ cnauto-assurance.Edit_assurance]" \
			 "[_ cnauto-assurance.Disapprove]" $disapprove_assurance_url "[_ cnauto-assurance.Disapprove_assurance]" \
			 "[_ cnauto-assurance.Close]" $close_assurance_url "[_ cnauto-assurance.Close_assurance]" \
			 "[_ cnauto-assurance.Cancel]" $return_url "[_ cnauto-assurance.Cancel]" \
			]
	
	
    } else {
	set approve_assurance_url [export_vars -base "change-assurance-status" {assurance_id {return_url $url} {status approved}}]
	set actions [list \
			 "[_ cnauto-assurance.Add]" $assurance_ae2_url "[_ cnauto-assurance.Add]" \
			 "[_ cnauto-assurance.Edit]" $assurance_ae_url "[_ cnauto-assurance.Edit_assurance]" \
			 "[_ cnauto-assurance.Open]" $approve_assurance_url "[_ cnauto-assurance.Open_assurance]" \
			 "[_ cnauto-assurance.Cancel]" $return_url "[_ cnauto-assurance.Cancel]" \
			]

    }
    

}

template::list::create \
    -name parts \
    -multirow parts \
    -actions $actions \
    -pass_properties { assurance_id } \
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


template::head::add_css -href "/resources/cnauto-assurance/assurance.css"


set url [site_node::get_url_from_object_id -object_id [ad_conn package_id]]


db_multirow -extend {view_image_url} files select_file {
    SELECT cr.description, cr.revision_id FROM cr_revisions cr, cr_items ci WHERE ci.parent_id = :assurance_id AND cr.item_id = ci.item_id
} {
    set view_image_url [export_vars -base "${url}view/$description" {revision_id}]

}
