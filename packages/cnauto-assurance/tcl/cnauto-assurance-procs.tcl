ad_library {

    CN Auto Assurance API

}


namespace eval cn_assurance {}


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





ad_proc -public cn_assurance::new { 
    {-dcn ""}
    {-assurance_number ""}
    {-assurance_date ""}
    {-status ""}
    {-lp ""}
    {-lp_date ""}
    {-lp_2 ""}
    {-lp_2_date ""}
    {-service_order ""} 
    {-service_order_date ""}
    {-vehicle_id ""}
    {-kilometers ""}
    {-part_group ""}
    {-part_code ""}
    {-part_quantity ""}
    {-damage_description ""}
    {-third_service ""}
    {-cost_price ""}
    {-assurance_price ""}
    {-tmo_code ""}
    {-tmo_duration ""}
    {-cost ""}
    {-ttl_sg ""}
    {-creation_ip ""}
    {-creation_user ""}
    {-context_id ""}    
} { 
    Add a new assurance
} {
    

    ns_log Notice "
			      -dcn $dcn \n
			      -assurance_number $assurance_number \n
			      -assurance_date $assurance_date \n
			      -status $status \n
			      -lp $lp \n
			      -lp_date $lp_date \n
			      -lp_2 $lp_2 \n
			      -lp_2_date $lp_2_date \n
			      -service_order $service_order \n
			      -service_order_date $service_order_date \n
			      -chassis $chassis \n
			      -kilometers $kilometers \n
			      -part_group $part_group \n
			      -part_code $part_code \n
			      -part_quantity $part_quantity \n
			      -damage_description $damage_description \n
			      -third_service $third_service \n
			      -cost_price $cost_price \n
			      -assurance_price $assurance_price \n
			      -tmo_code $tmo_code \n
			      -tmo_duration $tmo_duration \n
			      -cost  $cost \n
			      -ttl_sg $ttl_sg \n
			      -creation_ip [ad_conn peeraddr] \n
			      -creation_user [ad_conn user_id] \n
			      -context_id [ad_conn package_id] \n
"

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
				  :dcn,
				  :assurance_number,
				  :assurance_date,
				  :status,
				  :lp,
				  :lp_date,
				  :lp_2,
				  :lp_2_date,
				  :service_order, 
				  :service_order_date,
				  :chassis,
				  :kilometers,
				  :part_group,
				  :part_code,
				  :part_quantity,
				  :damage_description,
				  :third_service,
				  :cost_price,
				  :assurance_price,
				  :tmo_code,
				  :tmo_duration,
				  :cost,
				  :ttl_sg,
				  :creation_ip,
				  :creation_user,
				  :context_id
				  )
    }]
    
    return $assurance_id
}




ad_proc -public cn_assurance::get_color_options {} {
    
    Returns a list of lists to the ad_form select element 
    
} {
    
    return [db_list_of_lists select_colors { SELECT name, code FROM cn_colors }]
}