ad_page_contract {

} {
    upload_file:trim,optional
    upload_file.tmpfile:tmpfile,optional
    {assurance_id}
    {part_code:array,optional}
    {part_name:array,optional}
    {part_cost:array,optional}
    {part_quantity:array,optional}
    {assurance_cost:array,optional}
    {part_incomes:array,optional}
    {mo_code:array,optional}
    {mo_time:array,optional}
    {third_cost:array,optional}
    {description:optional}
    {parts_total_cost:optional}
    {assurance_total_cost:optional}
    {third_total_cost:optional}
    {mo_total_cost:optional}
    {total_cost:optional}
    {return_url ""}
    {submit.x:optional}
    {submit.file:optional}
    {lines "5"}
} 


if {[info exists submit.file]} {

    set tmp_filename ${upload_file.tmpfile}
    set filename [template::util::file::get_property filename $upload_file] 
    if { [catch { cn_core::attach_file \
		      -parent_id $assurance_id \
		      -tmp_filename $tmp_filename \
		      -filename $filename 
    } errmsg]} {
	ad_return_complaint 1 "[_ cnauto-assurance.Attach_file_failed]"
    }

    ad_returnredirect [export_vars -base "assurance-ae-2" {assurance_id return_url}]

}

if {[info exists submit.x]} {

    if { [catch { cn_assurance::detach_parts -assurance_id $assurance_id } errmsg]} {
	ad_return_complaint 1 "[_ cnauto-assurance.Detach_part_failed]"
    }



    for {set i 0} {$i < [array size part_code]} {incr i} {
	
	#ns_log Notice "$part_code($i) | $part_name($i)"
	
	
	set code $part_code($i)
	if {![string equal $code ""]} {
	    set part_id [db_string select_part_id {
		SELECT part_id FROM cn_parts WHERE code = :code
	    } -default null]
	    
	    if {[string equal $part_id "null"]} {
		ad_return_complaint 1 "The part insert does not exist on the database $part_code($i) - $part_name($i) <br /> Please <a href='javascript:history.go(-1)'><b>go back</b></a> and fix the error."
	    }
	    
	    cn_assurance::attach_parts \
		-assurance_id $assurance_id \
		-part_id $part_id \
		-cost  $part_cost($i) \
		-quantity $part_quantity($i) \
		-assurance $assurance_cost($i) \
		-income $part_incomes($i) \
		-mo_code $mo_code($i) \
		-mo_time $mo_time($i) \
		-third_cost $third_cost($i)
	    
	}
    }
    
    cn_assurance::update_costs \
	-assurance_id $assurance_id \
	-status "unapproved" \
	-description $description \
	-parts_total_cost $parts_total_cost \
	-assurance_total_cost $assurance_total_cost \
	-third_total_cost $third_total_cost \
	-mo_total_cost $mo_total_cost \
	-total_cost $total_cost

    set send_email_p [parameter::get -package_id [ad_conn package_id] -parameter "AssuranceEmailAlert" -default 0]
    
    if {$send_email_p} {
	
	ns_log Notice "SEND EMAIL"
	set from_address "iuri.sampaio@cnauto.com.br"
	set to_address [parameter::get -package_id [ad_conn package_id] -parameter "AssuranceEmailReceiver" -default ""]
	ns_log Notice "$to_address | $from_address"
	set date [clock format [clock seconds]]
	set body "Click here to analyze the  <a href=\"iurix.com/cnauto/assurance/assurance-one?assurance_id=$assurance_id\">assurance</a>"
	
	#acs_mail_lite::send \
	    -subject "New assurance required $date" \
	    -body $body \
	    -to_addr $to_address \
	    -from_addr $from_address \
	    -send_immediately
	
    }

    ns_log Notice "REDIRECT"
    ad_returnredirect [export_vars -base "/cnauto/assurances/" {}]
}



set title [_ cnauto-assurance.Add_parts]

db_1row select_assurance_number {
    SELECT assurance_number,parts_total_cost, assurance_total_cost, third_total_cost, mo_total_cost, total_cost, description FROM cn_assurances WHERE assurance_id = :assurance_id
}

set parts_html ""

template::multirow create parts i code pretty_name part_cost quantity assurance_cost incomes mo_code mo_time third_cost

set part_list [db_list_of_lists select_parts {
    SELECT cp.code, cp.pretty_name, apr.cost, apr.quantity, apr.assurance_cost, apr.incomes, apr.mo_code, apr.mo_time, apr.third_services_cost
    FROM cn_parts cp, cn_assurance_part_requests apr
    WHERE apr.assurance_id = :assurance_id
    AND cp.part_id = apr.part_id
}]


for {set i 0} {$i < $lines} {incr i} {

    if {$i < [llength $part_list]} {
	
	set code [lindex [lindex $part_list $i] 0]
	set pretty_name [lindex [lindex $part_list $i] 1] 
	set part_cost [lindex [lindex $part_list $i] 2]
	set quantity [lindex [lindex $part_list $i] 3]
	set assurance_cost [lindex [lindex $part_list $i] 4]
	set incomes [lindex [lindex $part_list $i] 5]
	set mo_code [lindex [lindex $part_list $i] 6]
	set mo_time [lindex [lindex $part_list $i] 7]
	set third_cost [lindex [lindex $part_list $i] 8]
	
	template::multirow append parts $i $code $pretty_name $part_cost $quantity $assurance_cost $incomes $mo_code $mo_time $third_cost
	ns_log Notice "TTTT $code"
    } else {
	template::multirow append parts $i "" "" ""
    }

}

set lines [expr $lines + 5]
set add_more_lines [export_vars -base "assurance-ae-2" {assurance_id vehicle_id lines}]

template::head::add_javascript -src "/resources/cnauto-assurance/js/js-library.js" -order 0

  
  

template::head::add_javascript -src "/resources/cnauto-assurance/js/jquery.js" -order 1

set javascript_attach_files {
<script type="text/javascript">
    $(document).ready(function(){
	
	$(".slidingDiv").hide();
	$(".show_hide").show();
	
	$('.show_hide').click(function(){
	    $(".slidingDiv").slideToggle();
	});
	
    });
</script>
}

template::head::add_css -href "/resources/cnauto-assurance/assurance.css"


template::multirow create files img filename

db_foreach file_attached {
    SELECT cr.description FROM cr_revisions cr, cr_items ci WHERE ci.parent_id = :assurance_id AND cr.item_id = ci.item_id
} {
    set img "/resources/file-storage/file.gif"
    template::multirow append files $img $description

}
