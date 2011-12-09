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

set year_options {"2000 2000" "2001 2001" "2002 2002" "2003 2003" "2004 2004" "2005 2005" "2006 2006" "2007 2007" "2008 2008" "2009 2009" "2010 2010" "2011 2011"}
#set year_options [db_list_of_lists select_years { SELECT EXTRACT(YEAR FROM INTERVAL ('now' + '10 years')); }]

ns_log Notice "$year_options"

ad_form -name assurance_ae -form {
    {assurance_id:key}
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
    {inform2:text(inform)
        {label "<h2>[_ cnauto-assurance.Assurance_info]</h2>"}
        {value ""}
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
} -on_submit {
} -new_data {
    
    set assurance_id [cn_assurance::new \
			  -chassis $chassis \
			  -model $model \
			  -engine $engine \
			  -color $color \
			  -year_of_model $year_of_model \
			  -year_of_fabrication $year_of_fabrication \
			  -purchase_date $purchase_date \
			  -arrival_date $arrival_date \
			  -billing_date $billing_date \
			  -duration $duration \
			  -distributor_code $distributor_code \
			  -owner $owner \
			  -phone $phone \
			  -postal_address $postal_address \
			  -postal_address2 $postal_address2 \
			  -postal_code $postal_code \
			  -state $state \
			  -country_code $country_code \
			  -notes $notes \
			  -creation_ip [ad_conn peeraddr] \
			  -creation_user [ad_conn user_id] \
			  -context_id [ad_conn package_id] \
			 ]

} -edit_data {
} -after_submit {
    ad_returnredirect $return_url
    ad_script_abort
}



