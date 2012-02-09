ad_library {

    CN Auto Assurance API

}


namespace eval cn_assurance {}
ad_proc -public cn_assurance::new { 
    {-assurance_number ""}
    {-assurance_date ""}
    {-service_order ""} 
    {-service_order_date ""}
    {-vehicle_id ""}
    {-kilometers ""}
    {-status ""}
    {-creation_ip ""}
    {-creation_user ""}
    {-context_id ""}    
} { 
    Add a new assurance
} {
    

    if {$creation_ip == ""} {
	set creation_ip [ad_conn peeraddr]
    }
    
    if {$creation_user == ""} {
	set creation_user [ad_conn user_id]
    }
     
    if {$context_id == ""} {
	set context_id [ad_conn package_id]
    }

    



    #set assurance_id [db_nextval acs_object_id_seq]
				    
    set assurance_id [db_exec_plsql insert_assurance {
	SELECT cn_assurance__new (
				  :assurance_number,
				  :assurance_date,
				  :service_order, 
				  :service_order_date,
				  :vehicle_id,
				  :kilometers,
				  :status,
				  :creation_ip,
				  :creation_user,
				  :context_id
				  )
    }]
    
    return $assurance_id
}



#####################
### BEGIN HTML FORM API
#####################

ad_proc -public cn_assurance::part_select_widget_html {
    {-name}
    {-key ""}
} {

    Generates a html select widget 
} {


    set html_select "<select name=\"${name}\" id=\"${name}\" onChange=\"return FillFieldsOnChange();\">"
    
    if {$key == ""} {
	set html_options "<option value=\"0\">#cnauto-assurance.Select#</option>"
    }

    set element_options [db_list_of_lists select_part_info {
	SELECT cp.part_id, cp.code FROM cn_parts cp 
	ORDER BY cp.code
    }]
    
    foreach element $element_options {
	append html_options "
          <option value='[lindex $element 0]'>[lindex $element 1]</option>
        "
    }
    
   
    append html_select $html_options
    append html_select "</select>"

    return $html_select
}


ad_proc -public cn_assurance::vehicle_select_widget_html {
    {-name}
    {-key ""}
} {

    Generates a html select widget 
} {


    set html_select "<select name=\"${name}\" id=\"${name}\" onChange=\"return FillFieldsOnChange();\">"
    
    if {$key == ""} {
	set html_options "<option value=\"0\">#cnauto-assurance.Select#</option>"
    } else {

	db_1row select_vehicle {
	    SELECT cv.vehicle_id, cv.vin FROM cn_vehicles cv WHERE vehicle_id = :key
	}

	set html_options "<option value=\"${vehicle_id}\">${vin}</option>"
    }

    set element_options [db_list_of_lists select_vehicle_info {
	SELECT cv.vehicle_id, cv.vin FROM cn_vehicles cv 
	ORDER BY cv.vin
    }]
    
    foreach element $element_options {
	append html_options "
          <option value='[lindex $element 0]'>[lindex $element 1]</option>
        "
    }
    
   
    append html_select $html_options
    append html_select "</select>"

    return $html_select
}


ad_proc -public cn_assurance::model_select_widget_html {
    {-name}
    {-key ""}
} {
    
    Generates a html select widget 
} {
    
    
    set html_select "<select name=\"${name}\" id=\"${name}\">"
    
    set category_id ""

    if {$key == ""} {
	set html_options "<option value=\"0\">#cnauto-assurance.Select#</option>"
    } else {
	
	db_1row select_pretty_name {
	    SELECT cc.category_id, cc.pretty_name FROM cn_categories cc, cn_vehicles cv
	    WHERE cc.category_id = cv.model_id
	    AND cv.vehicle_id = :key
	}
	
	set html_options "<option value=\"${category_id}\">${pretty_name}</option>"
    }
    
    set element_options [db_list_of_lists select_model_info {
	SELECT c1.category_id, c1.pretty_name FROM cn_categories c1, cn_categories c2 
	WHERE c1.parent_id = c2.category_id
	AND c2.name = 'models' AND c1.object_type = 'cn_vehicle'
	AND c1.category_id != :category_id
	ORDER BY c1.pretty_name
    }]
    
    foreach element $element_options {
	append html_options "
          <option value='[lindex $element 0]'>[lindex $element 1]</option>
        "
    }
    
    
    append html_select $html_options
    append html_select "</select>"
    
    return $html_select
}






ad_proc -public cn_assurance::distributor_select_widget_html {
    {-name}
    {-key ""}
} {

    Generates a html select widget 
} {


    set html_select "<select name=\"${name}\" id=\"${name}\">"
    
    set person_id ""

    if {$key == ""} {
	set html_options "<option value=\"0\">#cnauto-assurance.Select#</option>"
    } else {
	
	set count [db_string select_person_id {
	    SELECT COUNT(cp.person_id) FROM cn_persons cp, cn_vehicles cv 
	    WHERE cp.person_id = cv.distributor_id 
	    AND vehicle_id = :key
	} -default null ]

	if {$count == 1 } {
	    db_1row select_info {
		SELECT cp.person_id, cp.pretty_name FROM cn_persons cp, cn_vehicles cv 
		WHERE cp.person_id = cv.distributor_id 
		AND cv.vehicle_id = :key
		
	    }
	    
	    set html_options "<option value=\"$person_id\">$pretty_name</option>"
	} else {
	    set html_options "<option value=\"0\">#cnauto-assurance.Select#</option>" 
	}
	ns_log Notice "$html_options"
    }

    set element_options [db_list_of_lists select_person_info {
	SELECT cp.person_id, cp.pretty_name FROM cn_persons cp, cn_categories cc
	WHERE cp.type_id = cc.category_id
	AND cc.name = 'concessionarias'
	AND cp.person_id != :person_id
    }]
    
    foreach element $element_options {
	append html_options "
          <option value=\"[lindex $element 0]\">[lindex $element 1]</option>
        "
    }
    
    
    append html_select $html_options
    
    append html_select "</select>"
    
    
    return $html_select
    
}



ad_proc -public cn_assurance::owner_select_widget_html {
    {-name}
    {-key ""}
} {

    Generates a html select widget 
} {


    set html_select "<select name=\"${name}\" id=\"${name}\">"
    
    set person_id ""

    if {$key == ""} {
	set html_options "<option value=\"0\">#cnauto-assurance.Select#</option>"
    } else {
	
	set count [db_string select_person_id {
	    SELECT COUNT(cp.person_id) FROM cn_persons cp, cn_vehicles cv 
	    WHERE cp.person_id = cv.owner_id 
	    AND cv.vehicle_id = :key
	} -default null ]

	if {$count == 1} {
	    db_1row select_info {
		SELECT cp.person_id, cp.pretty_name FROM cn_persons cp, cn_vehicles cv 
		WHERE cp.person_id = cv.owner_id 
		AND cv.vehicle_id = :key
		
	    }
	    
	    set html_options "<option value=\"${person_id}\">${pretty_name}</option>"
	} else {
	    set html_options "<option value=\"0\">#cnauto-assurance.Select#</option>" 
	}
    }

    set element_options [db_list_of_lists select_person_info {
	SELECT cp.person_id, cp.pretty_name FROM cn_persons cp, cn_categories cc
	WHERE cp.type_id = cc.category_id
	AND cc.name = 'pessoafisica'
	AND cp.person_id != :person_id
	
    }]
    
    foreach element $element_options {
	append html_options "
          <option value=\"[lindex $element 0]\">[lindex $element 1]</option>
        "
    }
    
    
    append html_select $html_options
    
    append html_select "</select>"
    
    
    return $html_select
    
}





ad_proc -public cn_assurance::input_date_html {
    {-name}
    {-date 0}
} {

    Generates a date input widget
} {

    set html_format "<input type=\"hidden\" name=\"${name}.format\" value=\"YYYY MM DD\" >"

    ns_log Notice "$name | $date fdfd"
    if {$date != 0} {
	
	set year [db_string select_year { SELECT EXTRACT(YEAR FROM TIMESTAMP :date)}] 
	set month [db_string select_year { SELECT EXTRACT(MONTH FROM TIMESTAMP :date)}] 
	set day [db_string select_year { SELECT EXTRACT(DAY FROM TIMESTAMP :date)}] 

    } else {
	
	set year [db_string select_year { SELECT EXTRACT(YEAR FROM TIMESTAMP 'now()')}] 
	set month [db_string select_year { SELECT EXTRACT(MONTH FROM TIMESTAMP 'now()')}] 
	set day [db_string select_year { SELECT EXTRACT(DAY FROM TIMESTAMP 'now()')}] 
    }


    set html_year "
	<input type=\"text\" name=\"${name}.year\" id=\"${name}.year\" size=\"4\" maxlength=\"4\" value=\"${year}\">
    "

    set html_month "
	&nbsp;<select name=\"${name}.month\" id=\"${name}.month\" >
	<option value=\"${month}\" selected=\"selected\">${month}</option>
	<option value=\"1\">01</option>
	<option value=\"2\">02</option>
	<option value=\"3\">03</option>
	<option value=\"4\">04</option>
	<option value=\"5\">05</option>
	<option value=\"6\">06</option>
	<option value=\"7\">07</option>
	<option value=\"8\">08</option>
	<option value=\"9\">09</option>
	<option value=\"10\">10</option>
	<option value=\"11\">11</option>
	<option value=\"12\">12</option>
	</select>
    "

    set html_day "
	&nbsp;<select name=\"${name}.day\" id=\"${name}.day\" >
	<option value=\"${day}\" selected=\"selected\">${day}</option>
	<option value=\"1\">01</option>
	<option value=\"2\">02</option>
	<option value=\"3\">03</option>
	<option value=\"4\">04</option>
	<option value=\"5\">05</option>
	<option value=\"6\">06</option>
	<option value=\"7\">07</option>
	<option value=\"8\">08</option>
	<option value=\"9\">09</option>
	<option value=\"10\">10</option>
	<option value=\"11\">11</option>
	<option value=\"12\">12</option>
	<option value=\"13\">13</option>
	<option value=\"14\">14</option>
	<option value=\"15\">15</option>
	<option value=\"16\">16</option>
	<option value=\"17\">17</option>
	<option value=\"18\">18</option>
	<option value=\"19\">19</option>
	<option value=\"20\">20</option>
	<option value=\"21\">21</option>
	<option value=\"22\">22</option>
	<option value=\"23\">23</option>
	<option value=\"24\">24</option>
	<option value=\"25\">25</option>
	<option value=\"26\">26</option>
	<option value=\"27\">27</option>
	<option value=\"28\">28</option>
	<option value=\"29\">29</option>
	<option value=\"30\">30</option>
	<option value=\"31\">31</option>
	</select>
    "

    set javascript_button "
	<input type=\"button\" style=\"height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');\" onclick=\"return showCalendarWithDateWidget('${name}', 'y-m-d');\">

    "

    set date_html "$html_format\n $html_year \n $html_month \n $html_day \n $javascript_button"

    return $date_html

}


###########################
### End HTML Form API
###########################


ad_proc -public cn_assurance::generate_assurance_number {
    {-vehicle_id}
} {

    Generates the next assurance number
} {

    set count [db_string select_assurances { 
	SELECT COUNT(assurance_id) FROM cn_assurances WHERE vehicle_id = :vehicle_id
    }]
    
    set year [db_string select_year { SELECT EXTRACT(year from timestamp 'now()')}] 
    
    set seq [db_nextval cn_assurance_id_seq]
    
    set number "${year}${count}${seq}"

    return $number
}


ad_proc -public  cn_assurance::import_csv_file {
    {-input_file}
} {

    Imports CSV files to add assurance requires
} {

    ns_log Notice "Running ad_proc cn_assurance::import_csv_file"

    set input_file [open "${input_file}" r]
    set lines [split [read $input_file] \n]
    close $input_file

    # 0 DCN;
    # 1 SG;
    # 2 DATA SG;
    # 3 STATUS;
    # 4 LP;
    # 5 DATA LP;
    # 6 LP 2¦ vez;O
    # 7 OS;
    # 8 DATA OS;
    # 9 CHASSI;
    # 10 KM;
    # 11 CONJ.;
    # 12 CàDIGO DA PE.A;Q
    # 13 QTD PE.A;
    # 14 DEFEITO;
    # 15 SVC 3§;P
    # 16 RE.O CUSTO;
    # 17 PRE.O GARANTIA;
    # 18 COD TMO;
    # 19 TEMPO TMO;
    # 20 VALOR;
    # 21 TTL SG;;;;;;;

    foreach line $lines {
	set line [split $line {;}] 
	ns_log Notice "LINE $line"


	set dcn [lindex $line 0]
	set assurance_number [lindex $line 1]

	set assurance_date [lindex $line 2]
	set assurance_date [split $assurance_date {/}]
	set assurance_date "[lindex $assurance_date 2][lindex $assurance_date 1][lindex $assurance_date 0]"

	set status [lindex $line 3]
	set lp [lindex $line 4]

	set lp_date [lindex $line 5]
	set lp_date [split $lp_date {/}]
	set lp_date "[lindex $lp_date 2][lindex $lp_date 1][lindex $lp_date 0]"

	set lp_2 [lindex $line 6]
	set service_order [lindex $line 7]
	if {[regexp {[A-z]} $service_order]} {
	    set service_order ""
	}


	set service_order_date [lindex $line 8]
	set service_order_date [split $service_order_date {/}]
	set service_order_date "[lindex $service_order_date 2][lindex $service_order_date 1][lindex $service_order_date 0]"

	set chassis [lindex $line 9]

	set vehicle_id [cn_resources::vehicle::new -chassis $chassis]

	set kilometers [lindex $line 10]

	set part_code [lindex $line 12]
	set part_id [cn_resource::part::new -part_code $part_code]

	set part_group [lindex $line 11]
	set part_quantity [lindex $line 13]
	set damage_description [lindex $line 14]
	set third_service [lindex $line 15]
	set cost_price [lindex $line 16]
	set assurance_price [lindex $line 17]
	set tmo_code [lindex $line 18]
	set tmo_duration [lindex $line 19]
	set cost [lindex $line 20]
	set ttl_sg [lindex $line 21]
	
    }


    cn_assurance::new \
	-dcn $dcn \
	-assurance_number $assurance_number \
	-assurance_date $assurance_date \
	-status $status \
	-lp $lp \
	-lp_date $lp_date \
	-lp_2 $lp_2 \
	-service_order $service_order \
	-service_order_date $service_order_date \
	-vehicle_id $vehicle_id \
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
	-cost $cost \
	-ttl_sg $ttl_sg \
	-creation_ip [ad_conn peeraddr] \
	-creation_user [ad_conn user_id] \
	-context_id [ad_conn package_id]    
	

}









ad_proc -public cn_assurance::get_color_options {} {
    
    Returns a list of lists to the ad_form select element 
    
} {
    
    return [db_list_of_lists select_colors { SELECT name, code FROM cn_colors }]
}
