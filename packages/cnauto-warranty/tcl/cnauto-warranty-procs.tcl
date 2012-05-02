ad_library {

    CN Auto Warranty API

}


namespace eval cn_claim {}
ad_proc -public cn_claim::new { 
    {-claim_number ""}
    {-claim_date ""}
    {-service_order ""} 
    {-service_order_date ""}
    {-vehicle_id ""}
    {-kilometers ""}
    {-status ""}
    {-owner_id ""}
    {-distributor_id ""}
    {-creation_ip ""}
    {-creation_user ""}
    {-context_id ""}    
} { 
    Add a new claim

    @status pending, unapproved, approved, closed
    pending: the claim request lacks input information from the CN Auto distributor
    unapproved: the claim request is waiting for the CN Auto staff analyst
    approved: the claim request is approved by the CN Auto staff analyst
    close: the claim request was paid and finished by both parts

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

    



    #set claim_id [db_nextval acs_object_id_seq]
				    
    set claim_id [db_exec_plsql insert_claim {
	SELECT cn_claim__new (
				  :claim_number,
				  :claim_date,
				  :service_order, 
				  :service_order_date,
				  :vehicle_id,
				  :kilometers,
				  :status,
				  :owner_id,
				  :distributor_id,
				  :creation_ip,
				  :creation_user,
				  :context_id
				  )
    }]
    
    return $claim_id
}

ad_proc -public cn_claim::edit { 
    {-claim_id:required}
    {-claim_date ""}
    {-service_order ""} 
    {-vehicle_id ""}
    {-kilometers ""}
    {-owner_id ""}
    {-distributor_id ""}
} { 
    Edit claim info
    
    
} {
    
    db_transaction {
	db_exec_plsql update_claim {
	    SELECT cn_claim__edit (
				       :claim_id,
				       :claim_date,
				       :service_order, 
				       :vehicle_id,
				       :kilometers,
				       :owner_id,
				       :distributor_id
				       )
	}
    }
    
    return
}


ad_proc -public cn_claim::update_costs { 
    {-claim_id:required}
    {-status ""}
    {-description ""}
    {-parts_total_cost ""}
    {-claim_total_cost ""}
    {-third_total_cost ""}
    {-mo_total_cost ""}
    {-total_cost ""}
} { 

    Update claim costs    
    
} {
    
    db_transaction {
	db_exec_plsql update_claim {
	    SELECT cn_claim__update_costs (
				       :claim_id,
				       :status,
				       :description,
				       :parts_total_cost, 
				       :claim_total_cost,
				       :third_total_cost,
				       :mo_total_cost,
				       :total_cost
				       )
	}
    }
    
    return
}


ad_proc -public cn_claim::attach_parts { 
    {-claim_id:required}
    {-part_id:required}
    {-cost ""}
    {-quantity ""}
    {-claim ""}
    {-income ""}
    {-mo_code ""}
    {-mo_time ""}
    {-third_cost ""}
} { 
    Create warranties part's list on cn_claim_parts_requests
    
    
} {
    
    ns_log Notice "Running ad_proc cn_claim::attach_parts"
    
    
    db_transaction {
	set map_id [db_nextval acs_object_id_seq]
	
	db_exec_plsql map_claim_parts {
	    SELECT cn_apr__new (
				 :map_id,
				 :claim_id,
				 :part_id,
				 :cost,
				 :quantity,
				 :claim,
				 :income,
				 :mo_code,
				 :mo_time,
				 :third_cost
				 );
	}
    }
    
    return
}

ad_proc -public cn_claim::detach_parts { 
    {-claim_id:required}
} {
    Remoevs all parts attached to the claim
} {
    
    set map_ids [db_list select_map_id {
	SELECT map_id FROM cn_claim_part_requests WHERE claim_id = :claim_id
    }]
		 
    db_transaction {
	foreach map_id $map_ids {
	    db_exec_plsql delete_map {
		SELECT cn_apr__delete (:map_id)
	    }
	}
    }

    return
}



ad_proc -public cn_claim::change_status {
    {-claim_id:required}
    {-status:required}
} {
    Changes claim status
} {
    
    db_transaction {
	db_dml update_status {
	    UPDATE cn_warranties SET status = :status
	}
    }
    
    return
}

#####################
### BEGIN HTML API
#####################

ad_proc -public cn_claim::workflow_cicle_html {
    {-status:required}
} {
    Returns HTML code for the workflow cicle
} {

    switch $status {
	pending {
	    set workflow_html "
		<div id=\"timeline\"> <hr style=\"width:900px;position:relative;\">
		<span style=\"color:red;margin-left:5%;\">Pending</span>
		<span style=\"margin-left:21%;\">Unapproved</span>
		<span style=\"margin-left:21%;\">Approved</span>
		<span style=\"margin-left:22%;\">Closed</span>
		</div></div
		
		<ul class=\"list\">
		
		<li class=\"selected\">&nbsp;</li>
		<li class=\"line\">&nbsp;</li>
		<li class=\"line\">&nbsp;</li>
		<li class=\"line\">&nbsp;</li>
		<div>
		
		</ul>
	    "


	}

	unapproved {
	    set workflow_html "
		<div id=\"timeline\"> <hr style=\"width:900px;position:relative;\">
		<span style=\"margin-left:5%;\">Pending</span>
		<span style=\"color:red;margin-left:21%;\">Unapproved</span>
		<span style=\"margin-left:21%;\">Approved</span>
		<span style=\"margin-left:22%;\">Closed</span>
		</div></div
		
		<ul class=\"list\">
		
		<li class=\"past\">&nbsp;</li>
		<li class=\"selected\">&nbsp;</li>
		<li class=\"line\">&nbsp;</li>
		<li class=\"line\">&nbsp;</li>
		<div>
		
		</ul>
	    "

	}
	approved {

	    set workflow_html "
		<div id=\"timeline\"> <hr style=\"width:900px;position:relative;\">
		<span style=\"margin-left:5%;\">Pending</span>
		<span style=\"margin-left:21%;\">Unapproved</span>
		<span style=\"color:red;margin-left:21%;\">Approved</span>
		<span style=\"margin-left:22%;\">Closed</span>
		</div></div
		
		<ul class=\"list\">
		
		<li class=\"past\">&nbsp;</li>
		<li class=\"past\">&nbsp;</li>
		<li class=\"selected\">&nbsp;</li>
		<li class=\"line\">&nbsp;</li>
		<div>
		
		</ul>
	    "

	}
	closed {

	    set workflow_html "
		<div id=\"timeline\"> <hr style=\"width:900px;position:relative;\">
		<span style=\"margin-left:5%;\">Pending</span>
		<span style=\"margin-left:21%;\">Unapproved</span>
		<span style=\"margin-left:21%;\">Approved</span>
		<span style=\"color:red;margin-left:22%;\">Closed</span>
		</div></div
		
		<ul class=\"list\">
		
		<li class=\"past\">&nbsp;</li>
		<li class=\"past\">&nbsp;</li>
		<li class=\"past\">&nbsp;</li>
		<li class=\"selected\">&nbsp;</li>
		<div>
		
		</ul>
	    "

	}
    }
    
    return $workflow_html
}



#####################
### BEGIN HTML FROM API
#####################


ad_proc -public cn_claim::part_html_input {
    {-name}
    {-count}
    {-claim_id}
    {-part_id ""}
} {

    Generates a html input block for parts 
} {


    set html_select "<select name=\"${name}\" id=\"${name}\" onChange=\"document.claim_ae_2.submit();\">"
    
    set part_id ""
    
    if {$part_id == ""} {
	set html_options "<option value=\"0\">#cnauto-warranty.Select#</option>"
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
    



    set i $count

    append parts_html "
	<tr>
    	  <td>
              $html_select
          </td>
	  <td>
            <input type=\"text\" name=\"part_name.${i}\" id=\"part_name.${i}\">
          </td>
    	  <td>
            <input type=\"text\" name=\"part_cost.${i}\" id=\"part_cost.${i}\">
          </td>
    	  <td>
             <input type=\"text\" name=\"part_quantity.${i}\" id=\"parts_quantity.${i}\">
          </td>
    	  <td>
            <input type=\"text\" name=\"part_incomes.${i}\" id=\"part_incomes.${i}\">
          </td>
    	  <td>
            <input type=\"text\" name=\"part_claim_cost.${i}\" id=\"part_claim_cost.${i}\">
          </td>
    	  <td>
            <input type=\"text\" name=\"part_mo_code.${i}\" id=\"part_mo_code.${i}\">
          </td>
    	  <td>
            <input type=\"text\" name=\"part_mo_time.${i}\" id=\"part_mo_time.${i}\">
          </td>
    	  <td>
            <input type=\"text\" name=\"part_third_cost.${i}\" id=\"part_third_cost.${i}\">
          </td>
	</tr>
	
"

 

    return $parts_html
}


ad_proc -public cn_claim::vehicle_select_widget_html {
    {-name}
    {-key ""}
} {

    Generates a html select widget 
} {


    set html_select "<select name=\"${name}\" id=\"${name}\" onChange=\"return FillFieldsOnChange();\">"
    
    if {$key == ""} {
	set html_options "<option value=\"0\">#cnauto-warranty.Select#</option>"
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


ad_proc -public cn_claim::model_select_widget_html {
    {-name}
    {-key ""}
} {
    
    Generates a html select widget 
} {
    
    
    set html_select "<select name=\"${name}\" id=\"${name}\">"
    
    set category_id ""

    if {$key == ""} {
	set html_options "<option value=\"0\">#cnauto-warranty.Select#</option>"
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
	AND c2.name = 'models' AND c1.category_type = 'cn_vehicle'
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






ad_proc -public cn_claim::distributor_select_widget_html {
    {-name}
    {-key ""}
} {

    Generates a html select widget 
} {


    set html_select "<select name=\"${name}\" id=\"${name}\">"
    
    set person_id ""

    if {$key == ""} {
	set html_options "<option value=\"0\">#cnauto-warranty.Select#</option>"
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
	    set html_options "<option value=\"0\">#cnauto-warranty.Select#</option>" 
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



ad_proc -public cn_claim::owner_select_widget_html {
    {-name}
    {-key ""}
} {

    Generates a html select widget 
} {


    set html_select "<select name=\"${name}\" id=\"${name}\">"
    
    set person_id ""

    if {$key == ""} {
	set html_options "<option value=\"0\">#cnauto-warranty.Select#</option>"
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
	    set html_options "<option value=\"0\">#cnauto-warranty.Select#</option>" 
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





ad_proc -public cn_claim::input_date_html {
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


ad_proc -public cn_claim::generate_claim_number {
    {-vehicle_id}
} {

    Generates the next claim number
} {

    set count [db_string select_warranties { 
	SELECT COUNT(claim_id) FROM cn_warranties WHERE vehicle_id = :vehicle_id
    }]
    
    set year [db_string select_year { SELECT EXTRACT(year from timestamp 'now()')}] 
    
    set seq [db_nextval cn_claim_id_seq]
    
    set number "${year}${count}${seq}"

    return $number
}


ad_proc -public  cn_claim::import_csv_file {
    {-input_file}
} {

    Imports CSV files to add claim requires
} {

    ns_log Notice "Running ad_proc cn_claim::import_csv_file"

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
	set claim_number [lindex $line 1]

	set claim_date [lindex $line 2]
	set claim_date [split $claim_date {/}]
	set claim_date "[lindex $claim_date 2][lindex $claim_date 1][lindex $claim_date 0]"

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
	set claim_price [lindex $line 17]
	set tmo_code [lindex $line 18]
	set tmo_duration [lindex $line 19]
	set cost [lindex $line 20]
	set ttl_sg [lindex $line 21]
	
    }


    cn_claim::new \
	-dcn $dcn \
	-claim_number $claim_number \
	-claim_date $claim_date \
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
	-claim_price $claim_price \
	-tmo_code $tmo_code \
	-tmo_duration $tmo_duration \
	-cost $cost \
	-ttl_sg $ttl_sg \
	-creation_ip [ad_conn peeraddr] \
	-creation_user [ad_conn user_id] \
	-context_id [ad_conn package_id]    
}
