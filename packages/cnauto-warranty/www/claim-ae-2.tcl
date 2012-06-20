ad_page_contract {

} {
    upload_file:trim,optional
    upload_file.tmpfile:tmpfile,optional
    {claim_id}
    {claim_number ""}
    {code ""}
    {pretty_name ""}
    {part_cost ""}
    {quantity ""}
    {incomes ""}
    {claim_cost ""}
    {mo_code ""}
    {mo_time ""}
    {third_cost ""}
    {description ""}
    {parts_total_cost ""}
    {claim_total_cost ""}
    {third_total_cost ""}
    {mo_total_cost ""}
    {total_cost ""}
    {return_url ""}
    {submit.x:optional}
    {submit.file:optional}
    {lines "5"}
} 


if {[info exists submit.file]} {

    set tmp_filename ${upload_file.tmpfile}
    set filename [template::util::file::get_property filename $upload_file] 
    if { [catch { cn_core::attach_file \
		      -parent_id $claim_id \
		      -tmp_filename $tmp_filename \
		      -filename $filename 
    } errmsg]} {
	ad_return_complaint 1 "[_ cnauto-warranty.Attach_file_failed]"
    }

    ad_returnredirect [export_vars -base "claim-ae-2" {claim_id return_url}]

}

if {[info exists submit.x]} {

    if { [catch { cn_claim::detach_parts -claim_id $claim_id } errmsg]} {
	ad_return_complaint 1 "[_ cnauto-warranty.Detach_part_failed]"
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
	    
	    cn_claim::attach_parts \
		-claim_id $claim_id \
		-part_id $part_id \
		-cost  $part_cost($i) \
		-quantity $part_quantity($i) \
		-claim_cost $claim_cost($i) \
		-income $part_incomes($i) \
		-mo_code $mo_code($i) \
		-mo_time $mo_time($i) \
		-third_cost $third_cost($i)
	    
	}
    }
    
    cn_claim::update_costs \
	-claim_id $claim_id \
	-status "unapproved" \
	-description $description \
	-parts_total_cost $parts_total_cost \
	-claim_total_cost $claim_total_cost \
	-third_total_cost $third_total_cost \
	-mo_total_cost $mo_total_cost \
	-total_cost $total_cost

    set send_email_p [parameter::get -package_id [ad_conn package_id] -parameter "WarrantyEmailAlert" -default 0]
    
    if {$send_email_p} {
	
	ns_log Notice "SEND EMAIL"
	set from_address "iuri.sampaio@cnauto.com.br"
	set to_address [parameter::get -package_id [ad_conn package_id] -parameter "WarrantyEmailReceiver" -default ""]
	ns_log Notice "$to_address | $from_address"
	set date [clock format [clock seconds]]
	set body "Click here to analyze the  <a href=\"/cnauto/warranty/claim-one?claim_id=$claim_id\">Claim</a>"
	
	#acs_mail_lite::send \
	    -subject "New Claim required $date" \
	    -body $body \
	    -to_addr $to_address \
	    -from_addr $from_address \
	    -send_immediately
	
    }

    ns_log Notice "REDIRECT"
    ad_returnredirect [export_vars -base "/cnauto/warranty/" {}]
}



set title [_ cnauto-warranty.Add_parts]

db_1row select_claim_number {
    SELECT claim_number, parts_total_cost, claim_total_cost, third_total_cost, mo_total_cost, total_cost, description FROM cn_claims WHERE claim_id = :claim_id
}

set parts_html ""



db_multirow -extend {} parts select_parts {
    SELECT cp.code, cp.pretty_name, cpr.cost, cpr.quantity, cpr.claim_cost, cpr.incomes, cpr.mo_code, cpr.mo_time, cpr.third_services_cost
    FROM cn_parts cp, cn_claim_part_requests cpr
    WHERE cpr.claim_id = :claim_id
    AND cp.part_id = cpr.part_id
}




# Attach files chunk

template::head::add_javascript -src "/resources/cnauto-warranty/js/js-library.js" -order 0

template::head::add_javascript -src "/resources/cnauto-warranty/js/jquery.js" -order 1


set javascript_attach_files {
<script type="text/javascript">
    //alert($);
    (function($) {
	$(document).ready(function(){
	
	    $(".slidingDiv").hide();
	    $(".show_hide").show();
	    
	    $('.show_hide').click(function(){
		$(".slidingDiv").slideToggle();
	    });   
	});
    }) ( jQuery );
    
</script>
}




template::head::add_css -href "/resources/cnauto-warranty/warranty.css"


template::multirow create files img filename

db_foreach file_attached {
    SELECT cr.description FROM cr_revisions cr, cr_items ci WHERE ci.parent_id = :claim_id AND cr.item_id = ci.item_id
} {
    set img "/resources/file-storage/file.gif"
    template::multirow append files $img $description

}




# Autocomplete's Javascript
template::head::add_javascript -src "/resources/cnauto-warranty/js/autocomplete/prototype.js"

template::head::add_javascript -src "/resources/cnauto-warranty/js/autocomplete/effects.js"

template::head::add_javascript -src "/resources/cnauto-warranty/js/autocomplete/controls.js"

