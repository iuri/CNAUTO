ad_page_contract {
    Claim Detailed Info
} {
    claim_id
    {return_url ""}
    
}

set page_title [_ cnauto-warranty.Claim_info]


set resources_url "/cnauto/cnauto-resources"

set vehicle_id [db_string select_vehicle_id { SELECT vehicle_id FROM cn_claims WHERE claim_id = :claim_id } -default null]
set vehicle_one_url [export_vars -base "${resources_url}/vehicles/vehicle-one" {return_url vehicle_id}] 

set person_id [db_string select_vehicle_id { SELECT distributor_id FROM cn_claims WHERE claim_id = :claim_id }]
set distributor_one_url [export_vars -base "${resources_url}/persons/person-one" {return_url person_id {type_id 272111}}] 

set person_id [db_string select_vehicle_id { SELECT owner_id FROM cn_claims WHERE claim_id = :claim_id }]
set owner_one_url [export_vars -base "${resources_url}/persons/person-one" {return_url person_id {type_id 272235}}] 


set claim_ae_url [export_vars -base "claim-ae" {return_url claim_id}]
 
ad_form -name claim -mode display -has_edit 1  -form {
    {inform1:text(inform)
        {label "<h2>[_ cnauto-warranty.Claim_info]</h2>"}
        {value ""}
    }
    {claim_number:integer
	{label "[_ cnauto-warranty.Number]"}
	{value ""}
    }
    {claim_date:date
	{label "[_ cnauto-warranty.Claim_date]"}
	{format "YYYY MM DD"}
	{after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('claim_date', 'y-m-d');" > \[<b>[_ cnauto-warranty.y-m-d]</b>\]}} 
    }
    {status:text(text)
	{label "[_ cnauto-warranty.Status]"}
        {value ""}
    }
    {service_order:integer 
	{label "[_ cnauto-warranty.Service_order]"}
	{html {size 5} maxlength 10}
        {value ""}
    }
    {so_date:date
	{label "[_ cnauto-warranty.SO_date]"}
	{format "YYYY MM DD"}
	{after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('so_date', 'y-m-d');" > \[<b>[_ cnauto-warranty.y-m-d]</b>\]}}
	
    }
    {chassis:text(text)
	{label "[_ cnauto-warranty.Chassis]"}
	{help_text "<a href=\"${vehicle_one_url}\">#cnauto-warranty.Vehicle_details#</a>"}
    }
    {kilometers:integer
	{label "[_ cnauto-warranty.Kilometers]"}
	{html {size 10} maxlength 10}
        {value ""}
    }
    {distributor_name:text
	{label "[_ cnauto-warranty.Distributor]"}
	{help_text "<a href=\"${distributor_one_url}\">#cnauto-warranty.Distributor_details#</a>"}
    }
    {owner_name:text
	{label "[_ cnauto-warranty.Owner]"}
	{help_text "<a href=\"${owner_one_url}\">#cnauto-warranty.Owner_details#</a>"}
    }
    {parts_total_cost:text
	{label "[_ cnauto-warranty.Parts_total]"}
    }
    {claim_total_cost:text
	{label "[_ cnauto-warranty.Claim_total]"}
    }
    {third_total_cost:text
	{label "[_ cnauto-warranty.Total_third]"}
    }
    {mo_total_cost:text
	{label "[_ cnauto-warranty.Total_MO]"}
    }
    {total_cost:text
	{label "[_ cnauto-warranty.Total]"}
    }
    {description:text(textarea)
	{label "[_ cnauto-warranty.Description]"}
	{html {rows 50 cols 100}}
    }

} -on_request {
    
    db_1row select_claim_info {
	SELECT cc.claim_number, cc.claim_date, cc.status, cc.service_order, cc.service_order_date AS so_date, cc.vehicle_id, cv.vin AS chassis, cc.kilometers, parts_total_cost, claim_total_cost, third_total_cost, mo_total_cost, total_cost, description, cp1.person_id AS owner_id, cp1.pretty_name AS owner_name, cp2.person_id AS distributor_id, cp2.pretty_name AS distributor_name 
	FROM cn_claims cc
	LEFT OUTER JOIN cn_persons cp1 ON (cp1.person_id = cc.owner_id)
	LEFT OUTER JOIN cn_persons cp2 ON (cp2.person_id = cc.distributor_id)
	LEFT OUTER JOIN cn_vehicles cv ON (cv.vehicle_id = cc.vehicle_id)
	WHERE cc.claim_id = :claim_id
    }

    
    set workflow_html [cn_claim::workflow_cicle_html -status $status]


   # set assurance_date [template::util::date::from_ansi $assurance_date [lc_get formbuilder_time_format]]

    #set service_order_date [template::util::date::from_ansi $so_date [lc_get formbuilder_time_format]]
}

set actions [list]

set admin_p [permission::permission_p -object_id [ad_conn package_id] -party_id [ad_conn user_id] -privilege "admin"]

if {$admin_p} {
    set url [ad_conn url]

    set claim_ae2_url [export_vars -base "claim-ae-2" {return_url claim_id}]


    set close_claim_url [export_vars -base "change-claim-status" {{return_url $url} assurance_id {status closed}}]

    if {$status == "unapproved"} {
	set approve_claim_url [export_vars -base "change-claim-status" {assurance_id {return_url $url} {status approved}}]


	set actions [list \
			 "[_ cnauto-warranty.Add]" $claim_ae2_url "[_ cnauto-warranty.Add]" \
			 "[_ cnauto-warranty.Edit]" $claim_ae_url "[_ cnauto-warranty.Edit_claim]" \
			 "[_ cnauto-warranty.Approve]" $approve_claim_url "[_ cnauto-warranty.Approve_claim]" \
			 "[_ cnauto-warranty.Close]" $close_claim_url "[_ cnauto-warranty.Close_claim]" \
			 "[_ cnauto-warranty.Cancel]" $return_url "[_ cnauto-warranty.Cancel]" \
			]
	
	
    } elseif {$status == "approved"} {
	set disapprove_claim_url [export_vars -base "change-claim-status" {claim_id {return_url $url} {status unapproved}}]
	
	set actions [list \
			 "[_ cnauto-warranty.Add]" $claim_ae2_url "[_ cnauto-warranty.Add]" \
			 "[_ cnauto-warranty.Edit]" $claim_ae_url "[_ cnauto-warranty.Edit_claim]" \
			 "[_ cnauto-warranty.Disapprove]" $disapprove_claim_url "[_ cnauto-warranty.Disapprove_claim]" \
			 "[_ cnauto-warranty.Close]" $close_claim_url "[_ cnauto-warranty.Close_claim]" \
			 "[_ cnauto-warranty.Cancel]" $return_url "[_ cnauto-warranty.Cancel]" \
			]
	
	
    } else {
	set approve_claim_url [export_vars -base "change-claim-status" {claim_id {return_url $url} {status approved}}]
	set actions [list \
			 "[_ cnauto-warranty.Add]" $claim_ae2_url "[_ cnauto-warranty.Add]" \
			 "[_ cnauto-warranty.Edit]" $claim_ae_url "[_ cnauto-warranty.Edit_claim]" \
			 "[_ cnauto-warranty.Open]" $approve_claim_url "[_ cnauto-warranty.Open_claim]" \
			 "[_ cnauto-warranty.Cancel]" $return_url "[_ cnauto-warranty.Cancel]" \
			]

    }
    

}

template::list::create \
    -name parts \
    -multirow parts \
    -actions $actions \
    -pass_properties { claim_id } \
    -elements {
	code {
	    label "[_ cnauto-warranty.Code]"
	}
	name {
	    label "[_ cnauto-warranty.Name]"
	}
	cost {
	    label "[_ cnauto-warranty.Cost]"
	}
	claim_cost {
	    label "[_ cnauto-warranty.Claim_cost]"
	}
	quantity {
	    label "[_ cnauto-warranty.Quantity]"
	}
	incomes {
	    label "[_ cnauto-warranty.Incomes]"
	}
	mo_code {
	    label "[_ cnauto-warranty.MO_code]"
	}
	mo_time {
	    label "[_ cnauto-warranty.MO_time]"
	}
	third_services_cost {
	    label "[_ cnauto-warranty.Third_services_cost]"
	}
    }

db_multirow -extend {} parts select_parts {
    SELECT cp.code, cp.name, cpr.cost, cpr.quantity, cpr.claim_cost, cpr.incomes, cpr.mo_code, cpr.mo_time, cpr.third_services_cost
    FROM cn_claim_part_requests cpr, cn_parts cp
    WHERE cpr.claim_id = :claim_id
    AND cpr.part_id = cp.part_id 
}


template::head::add_css -href "/resources/cnauto-warranty/warranty.css"


set url [site_node::get_url_from_object_id -object_id [ad_conn package_id]]


db_multirow -extend {view_image_url} files select_file {
    SELECT cr.description, cr.revision_id FROM cr_revisions cr, cr_items ci WHERE ci.parent_id = :claim_id AND cr.item_id = ci.item_id
} {
    set view_image_url [export_vars -base "${url}view/$description" {revision_id}]

}
