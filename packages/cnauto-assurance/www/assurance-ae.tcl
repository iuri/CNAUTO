ad_page_contract {
    
    Add/Edit Assurance Requirement

} {
    {assurance_id:integer,optional}
    {state ""}
    {return_url ""}
}


if { [exists_and_not_null cal_item_id] } {
    set page_title [_ cnauto-assurance.Edit_Item]
    #set ad_form_mode display
} else {
    set page_title [_ cnauto-assurance.Add_Item]
    #set ad_form_mode edit
}


 
set color_options [cn_assurance::get_color_options]


set where_clause ""
if {[exists_and_not_null state]} {
    set where_clause "WHERE state_code = :state"
}


set municipality_options [db_list_of_lists select_municipality "
    SELECT name, ibge_code FROM br_ibge_municipality $where_clause ORDER BY name
"]

set state_options [db_list_of_lists select_states { SELECT state_name, abbrev FROM br_states }]

set year_options [db_list select_years {
    SELECT EXTRACT(YEAR FROM TIMESTAMP 'now');    
}]

ns_log Notice "$year_options"

ad_form -name assurance_ae -form {
    {assurance_id:key}
    {inform1:text(inform)
        {label "<h2>[_ cnauto-assurance.Assurance_info]</h2>"}
        {value ""}
    }
    {chassis:text(text)
	{label "[_ cnauto-asssurance.Chassis]"}
    }
    {model:text(text)
	{label "[_ cnauto-asssurance.Chassis]"}
    }
    {purchase_date:date
	{label "[_ cnauto-assurance.Purchase_date]"}
	{format "YYYY MM DD"}
	{after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('purchase_date', 'y-m-d');" > \[<b>[_ calendar.y-m-d]</b>\]} 
	} 
    }
    {duration:text(text)
	{label "[_ cnauto-assurance.Duration]"}
    }
    {distribution:integer
	{label "[_ cnauto-assurance.Distribution]"}
    }
    {owner:text(text)
	{label "[_ cnauto-assurance.Owner]"}
	{html {size 40} maxlength 255}
    }
    {phone:text(text)
	{label "[_ cnauto-assurance.Phone]"}
	{html {size 20} maxlength 15}
    }	
    {postal_address:text(text)
	{label "[_ cnauto-assurance.Postal_address]"}
	{html {size 60} maxlength 255}
    }
    {postal_address2:text(text)
	{label "[_ cnauto-assurance.Postal_address2]"}
	{html {size 60} maxlength 255}
    }
    {postal_code:text(text)
	{label "[_ cnauto-assurance.Postal_code]"}
	{html {size 60} maxlength 50}
    }
    {state:text(select)
	{label "[_ cnauto-assurance.State]"}
	{options $state_options}
	{html {onChange "document.assurance_ae.__refreshing_p.value='1';document.assurance_ae.submit()"}}
    }
    {municipality_code:text(select)
	{label "[_ cnauto-assurance.Countries]"}
	{options $municipality_options}
    }
    {country_code:text(hidden)
	{value "BR"}
    }
    {notes:text(textarea)
	{label "[_ cnauto-assurance.Notes]"}
    }
    {inform2:text(inform)
        {label "<h2>[_ cnauto-assurance.Vehicle_info]</h2>"}
        {value ""}
    }
    {year_of_model:text(select)
	{label "[_ cnauto-assurance.Year_of_model]"}
	{options $year_options}
    } 
    {year_of_fabrication:text(select)
	{label "[_ cnauto-assurance.Year_of_fabricant]"}
	{options $year_options}
    } 
    {engine:text(text)
	{label "[_ cnauto-assurance.Engine]"}
    }	
    {color:integer(select)
	{label "[_ cnauto-assurance.Color]"}
	{options $color_options}
    }
} -on_submit {
} -new_data {
} -edit_data {
} -after_submit {
    ad_returnredirect $return_url
    ad_script_abort
}



