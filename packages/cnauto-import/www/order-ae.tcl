ad_page_contract {
    
    Add/Edit Import Order

} {
    {order_id:integer,optional}
    {cnimp_number ""}
    {parent_id ""}
    {provider_id:integer,optional 0}
    {cnimp_date ""}
    {approval_date ""}
    {li_need_p ""}
    {payment_date ""}
    {manufactured_date ""}
    {payment_date ""}
    {departure_date ""}
    {arrival_date ""}
    {awb_bl_number ""}
    {numerary_date ""}
    {di_date ""}
    {di_status ""}
    {nf_date ""}
    {delivery_date ""}
    {incoterm_id:integer,optional 0}
    {transport_type:integer,optional 0}
    {order_cost:float,optional 0}
    {exchange_rate_type:integer,optional 0}
    {lc_number ""}
    {start_date ""}
    {notes ""}
    {step:integer,optional 0}
    {return_url ""}
}

set myform [ns_getform]
if {[string equal "" $myform]} {
    ns_log Notice "No Form was submited"
} else {
    ns_log Notice "FORM"
    ns_set print $myform
}

if { [exists_and_not_null order_id] } {
    set page_title [_ cnauto-import.Edit_order]
    #set ad_form_mode display
} else {
    set page_title [_ cnauto-import.Add_order]
    #set ad_form_mode edit
}


set provider_options [cn_import::get_provider_options]
set incoterm_options [cn_import::get_incoterm_options]
set parent_options [cn_import::get_parent_options]
set transport_options ""


ad_form -name order_ae -cancel_url $return_url -form {
    {order_id:key}
}

switch $step {
    1 { 
	ad_form -extend -name order_ae -form {
	    {inform1:text(inform)
		{label "<h2>[_ cnauto-import.CNIMP]</h2>"}
	    }
	    {cnimp_number:text(text)
		{label "[_ cnauto-import.CNIMP]"}
		{html {size 15} maxlength 15}
	    }
	    {parent_id:text(select),optional
		{label "[_ cnauto-import.Parent]"}
		{options $parent_options}
	    }   
	    {provider_id:integer(select),optional
		{label "[_ cnauto-import.Provider]"}
		{options $provider_options}
	    }
	    {cnimp_date:date,optional
		{label "[_ cnauto-import.CNIMP]"}
		{format "YYYY MM DD"}
		{help_text "[_ cnauto-import.y-m-d]"}
		{after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('cnimp_date', 'y-m-d');" >} }
	    }
	    {approval_date:date,optional
		{label "[_ cnauto-import.Approval_date]"}
		{format "YYYY MM DD"}
		{help_text "[_ cnauto-import.y-m-d]"}
		{after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('approval_date', 'y-m-d');" >} }
	    }
	    {li_need_p:boolean(checkbox),optional
		{label "[_ cnauto-import.LI_need_p]"}
		{options {{"" 1}}}
	    }
	    {payment_date:date(hidden) {value $payment_date}}
	    {manufactured_date:date(hidden) {value $manufactured_date}}
	    {departure_date:date(hidden) {value $departure_date}}
	    {arrival_date:date(hidden) {value $arrival_date}}
	    {awb_bl_number:text(hidden) {value $awb_bl_number}}
	    {numerary_date:date(hidden) {value $numerary_date}}
	    {di_date:date(hidden) {value $di_date}}
	    {di_status:text(hidden) {value $di_status}}
	    {nf_date:date(hidden) {value $nf_date}}
	    {delivery_date:date(hidden) {value $delivery_date}} 
	    {incoterm_id:integer(hidden) {value $incoterm_id}}
	    {transport_type:integer(hidden) {value $transport_type}}
	    {order_cost:float(hidden) {value $order_cost}}
	    {exchange_rate_type:integer(hidden) {value $exchange_rate_type}}
	    {lc_number:text(hidden) {value $lc_number}}
	    {start_date:date(hidden) {value $start_date}}
	    {notes:text(hidden) {value $notes}}    
	    {step:integer(hidden) {value $step}}
	}
    }

    2 {
	ad_form -extend -name order_ae -form {
	    {cnimp_number:text(hidden) {value $cnimp_number}}
	    {parent_id:text(hidden) {value $parent_id}}
	    {provider_id:integer(hidden) {value $provider_id}}
	    {cnimp_date:date(hidden) {value $cnimp_date}}
	    {approval_date:date(hidden) {value $approval_date}}
	    {li_need_p:boolean(hidden) {value $li_need_p}}
	    {inform2:text(inform)
		{label "<h2>[_ cnauto-import.Departure]</h2>"}
	    }
	    {payment_date:date,optional
		{label "[_ cnauto-import.Payment_date]"}
		{format "YYYY MM DD"}
		{help_text "[_ cnauto-import.y-m-d]"}
		{after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('payment_date', 'y-m-d');" >} }
	    }
	    {manufactured_date:date,optional
		{label "[_ cnauto-import.Manufactured_date]"}
		{format "YYYY MM DD"}
		{help_text "[_ cnauto-import.y-m-d]"}
		{after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('manufactured_date', 'y-m-d');" >} }
	    }
	    {departure_date:date,optional
		{label "[_ cnauto-import.Departure_date]"}
		{format "YYYY MM DD"}
		{help_text "[_ cnauto-import.y-m-d]"}
		{after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('departure_date', 'y-m-d');" >} }
	    }
	    {arrival_date:date,optional
		{label "[_ cnauto-import.Arrival_date]"}
		{format "YYYY MM DD"}
		{help_text "[_ cnauto-import.y-m-d]"}
		{after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('arrival_date', 'y-m-d');" >} }
	    }
	    {awb_bl_number:text(text),optional
		{label "[_ cnauto-import.AWB_BL_number]"}
		{html {size 15} maxlength 15}
	    }
	    {numerary_date:date(hidden) {value $numerary_date}}
	    {di_date:date(hidden) {value $di_date}}
	    {di_status:text(hidden) {value $di_status}}
	    {nf_date:date(hidden) {value $nf_date}}
	    {delivery_date:date(hidden) {value $delivery_date}} 
	    {incoterm_id:integer(hidden) {value $incoterm_id}}
	    {transport_type:integer(hidden) {value $transport_type}}
	    {order_cost:float(hidden) {value $order_cost}}
	    {exchange_rate_type:integer(hidden) {value $exchange_rate_type}}
	    {lc_number:text(hidden) {value $lc_number}}
	    {start_date:date(hidden) {value $start_date}}
	    {notes:text(hidden) {value $notes}}    
	    {step:integer(hidden) {value $step}}
	    
	}
    }
    3 {
	ad_form -extend -name order_ae -form {      	   
	    {cnimp_number:text(hidden) {value $cnimp_number}}
	    {parent_id:text(hidden) {value $parent_id}}
	    {provider_id:integer(hidden) {value $provider_id}}
	    {cnimp_date:date(hidden) {value $cnimp_date}}
	    {approval_date:date(hidden) {value $approval_date}}
	    {li_need_p:boolean(hidden) {value $li_need_p}}
	    {payment_date:date(hidden) {value $payment_date}}
	    {manufactured_date:date(hidden) {value $manufactured_date}}
	    {departure_date:date(hidden) {value $departure_date}}
	    {arrival_date:date(hidden) {value $arrival_date}}
	    {awb_bl_number:text(hidden) {value $awb_bl_number}}
	    {inform3:text(inform)
		{label "<h2>[_ cnauto-import.DI]</h2>"}
	    }
	    {numerary_date:date,optional
		{label "[_ cnauto-import.Numerary_date]"}
		{format "YYYY MM DD"}
		{help_text "[_ cnauto-import.y-m-d]"}
		{after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('numerary_date', 'y-m-d');" >} }
	    }
	    {di_date:date,optional
		{label "[_ cnauto-import.DI_date]"}
		{format "YYYY MM DD"}
		{help_text "[_ cnauto-import.y-m-d]"}
		{after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('di_date', 'y-m-d');" >} }
	    }
	    {di_status:text(select),optional
		{label "[_ cnauto-import.DI_status]"}
		{options {{"[_ cnauto-import.Green]" "green"} {"[_ cnauto-import.Yellow]" "yellow"} {"[_ cnauto-import.Red]" "red"} {"[_ cnauto-import.Gray]" "gray"} }}
	    }
	    {nf_date:date,optional
		{label "[_ cnauto-import.NF_date]"}
		{format "YYYY MM DD"}
		{help_text "[_ cnauto-import.y-m-d]"}
		{after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('nf_date', 'y-m-d');" >} }
	    }
	    {delivery_date:date,optional
		{label "[_ cnauto-import.Delivery_date]"}
		{format "YYYY MM DD"}
		{help_text "[_ cnauto-import.y-m-d]"}
		{after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('delivery_date', 'y-m-d');" >} }
	    }
	    {incoterm_id:integer(hidden) {value $incoterm_id}}
	    {transport_type:integer(hidden) {value $transport_type}}
	    {order_cost:float(hidden) {value $order_cost}}
	    {exchange_rate_type:integer(hidden) {value $exchange_rate_type}}
	    {lc_number:text(hidden) {value $lc_number}}
	    {start_date:date(hidden) {value $start_date}}
	    {notes:text(hidden) {value $notes}}    
	    {step:integer(hidden) {value $step}}
	}
    }
    4 {
	ad_form -extend -name order_ae -form {      	   
	    {cnimp_number:text(hidden) {value $cnimp_number}}
	    {parent_id:text(hidden) {value $parent_id}}
	    {provider_id:integer(hidden) {value $provider_id}}
	    {cnimp_date:date(hidden) {value $cnimp_date}}
	    {approval_date:date(hidden) {value $approval_date}}
	    {li_need_p:boolean(hidden) {value $li_need_p}}
	    {payment_date:date(hidden) {value $payment_date}}
	    {manufactured_date:date(hidden) {value $manufactured_date}}
	    {departure_date:date(hidden) {value $departure_date}}
	    {arrival_date:date(hidden) {value $arrival_date}}
	    {awb_bl_number:text(hidden) {value $awb_bl_number}}
	    {numerary_date:date(hidden) {value $numerary_date}}
	    {di_date:date(hidden) {value $di_date}}
	    {di_status:text(hidden) {value $di_status}}
	    {nf_date:date(hidden) {value $nf_date}}
	    {delivery_date:date(hidden) {value $delivery_date}} 
	    {step:integer(hidden) {value $step}}
	    {incoterm_id:integer(select),optional
		{label "[_ cnauto-import.Incoterm]"}
		{options $incoterm_options}
	    }
	    {transport_type:integer(select),optional
		{label "[_ cnauto-import.Port_Airport]"}
		{options {{"[_ cnauto-import.Seaport]" 1} {"[_ cnauto-import.Airport]" 2}}}
	    }
	    {inform4:text(inform),optional
		{label "<h2>[_ cnauto-import.Order]</h2>"}
	    }
	    {order_cost:float,optional
		{label "[_ cnauto-import.Order_cost]"}
	    }
	    {exchange_rate_type:integer(select),optional
		{label "[_ cnauto-import.Exchange_rate_type]"}
		{options {{"[_ cnauto-import.TT]" 1} {"[_ cnauto-import.LC]" 2} }}
	    }
	    {lc_number:text(text),optional
		{label "[_ cnauto-import.LC_number]"}
		{html {size 10} maxlength 10}
	    }
	    {start_date:date,optional
		{label "[_ cnauto-import.start_date]"}
		{format "YYYY MM DD"}
		{help_text "[_ cnauto-import.y-m-d]"}
		{after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('start_date', 'y-m-d');" >} }
	    }
	    {notes:text(textarea),optional
		{label "[_ cnauto-import.Notes]"}
		{html {cols 50 rows 10}}
	    }        
	}	    
    }
    5 { 
	ad_form -extend -name order_ae -form {      	   
	    {inform1:text(inform)
		{label "<h2>[_ cnauto-import.CNIMP]</h2>"}
	    }
	    {cnimp_number:text(text)
		{label "[_ cnauto-import.CNIMP]"}
		{html {size 15} maxlength 15}
	    }
	    {parent_id:text(select),optional
		{label "[_ cnauto-import.Parent]"}
		{options $parent_options}
	    }   
	    {provider_id:integer(select),optional
		{label "[_ cnauto-import.Provider]"}
		{options $provider_options}
	    }
	    {cnimp_date:date,optional
		{label "[_ cnauto-import.CNIMP]"}
		{format "YYYY MM DD"}
		{help_text "[_ cnauto-import.y-m-d]"}
		{after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('cnimp_date', 'y-m-d');" >} }
	    }
	    {approval_date:date,optional
		{label "[_ cnauto-import.Approval_date]"}
		{format "YYYY MM DD"}
		{help_text "[_ cnauto-import.y-m-d]"}
		{after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('approval_date', 'y-m-d');" >} }
	    }
	    {li_need_p:boolean(checkbox),optional
		{label "[_ cnauto-import.LI_need_p]"}
		{options {{"" 1}}}
	    }
	    
	    {inform2:text(inform)
		{label "<h2>[_ cnauto-import.Departure]</h2>"}
	    }
	    {payment_date:date,optional
		{label "[_ cnauto-import.Payment_date]"}
		{format "YYYY MM DD"}
		{help_text "[_ cnauto-import.y-m-d]"}
		{after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('payment_date', 'y-m-d');" >} }
	    }
	    {manufactured_date:date,optional
		{label "[_ cnauto-import.Manufactured_date]"}
		{format "YYYY MM DD"}
		{help_text "[_ cnauto-import.y-m-d]"}
		{after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('manufactured_date', 'y-m-d');" >} }
	    }
	    {departure_date:date,optional
		{label "[_ cnauto-import.Departure_date]"}
		{format "YYYY MM DD"}
		{help_text "[_ cnauto-import.y-m-d]"}
		{after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('departure_date', 'y-m-d');" >} }
	    }
	    {arrival_date:date,optional
		{label "[_ cnauto-import.Arrival_date]"}
		{format "YYYY MM DD"}
		{help_text "[_ cnauto-import.y-m-d]"}
		{after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('arrival_date', 'y-m-d');" >} }
	    }
	    {awb_bl_number:text(text),optional
		{label "[_ cnauto-import.AWB_BL_number]"}
		{html {size 15} maxlength 15}
	    }
	    {inform3:text(inform)
		{label "<h2>[_ cnauto-import.DI]</h2>"}
	    }
	    {numerary_date:date,optional
		{label "[_ cnauto-import.Numerary_date]"}
		{format "YYYY MM DD"}
		{help_text "[_ cnauto-import.y-m-d]"}
		{after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('numerary_date', 'y-m-d');" >} }
	    }
	    {di_date:date,optional
		{label "[_ cnauto-import.DI_date]"}
		{format "YYYY MM DD"}
		{help_text "[_ cnauto-import.y-m-d]"}
		{after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('di_date', 'y-m-d');" >} }
	    }
	    {di_status:text(select),optional
		{label "[_ cnauto-import.DI_status]"}
		{options {{"[_ cnauto-import.Green]" "green"} {"[_ cnauto-import.Yellow]" "yellow"} {"[_ cnauto-import.Red]" "red"} {"[_ cnauto-import.Gray]" "gray"} }}
	    }
	    {nf_date:date,optional
		{label "[_ cnauto-import.NF_date]"}
		{format "YYYY MM DD"}
		{help_text "[_ cnauto-import.y-m-d]"}
		{after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('nf_date', 'y-m-d');" >} }
	    }
	    {delivery_date:date,optional
		{label "[_ cnauto-import.Delivery_date]"}
		{format "YYYY MM DD"}
		{help_text "[_ cnauto-import.y-m-d]"}
		{after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('delivery_date', 'y-m-d');" >} }
	    }
	    {incoterm_id:integer(select),optional
		{label "[_ cnauto-import.Incoterm]"}
		{options $incoterm_options}
	    }
	    {transport_type:integer(select),optional
		{label "[_ cnauto-import.Port_Airport]"}
		{options {{"[_ cnauto-import.Seaport]" 1} {"[_ cnauto-import.Airport]" 2}}}
	    }
	    {inform4:text(inform),optional
		{label "<h2>[_ cnauto-import.Order]</h2>"}
	    }
	    {order_cost:float,optional
		{label "[_ cnauto-import.Order_cost]"}
	    }
	    {exchange_rate_type:integer(select),optional
		{label "[_ cnauto-import.Exchange_rate_type]"}
		{options {{"[_ cnauto-import.TT]" 1} {"[_ cnauto-import.LC]" 2} }}
	    }
	    {lc_number:text(text),optional
		{label "[_ cnauto-import.LC_number]"}
		{html {size 10} maxlength 10}
	    }
	    {start_date:date,optional
		{label "[_ cnauto-import.Delivery_date]"}
		{format "YYYY MM DD"}
		{help_text "[_ cnauto-import.y-m-d]"}
		{after_html {<input type="button" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');" onclick ="return showCalendarWithDateWidget('start_date', 'y-m-d');" >} }
	    }
	    {notes:text(textarea),optional
		{label "[_ cnauto-import.Notes]"}
		{html {cols 50 rows 10}}
	    }        
	}
    }
}



ad_form -extend -name order_ae -on_submit {} -edit_request {

    db_1row select_order_info {
	SELECT cio.parent_id, cio.cnimp_number, cio.provider_id, cp.pretty_name AS provider, cio,cnimp_date, cio.approval_date, cio.li_need_p, cio.payment_date, cio.manufactured_date, cio.departure_date, cio.awb_bl_number, cio.arrival_date, cio.numerary_date, cio.di_date, cio.di_status, cio.nf_date, cio.delivery_date, cio.incoterm_id, cio.transport_type, cio.order_cost, cio.exchange_rate_type, cio.lc_number, cio.start_date, cio.notes 
	FROM cn_import_orders cio
	LEFT OUTER JOIN cn_persons cp ON (cp.person_id = cio.provider_id)
	WHERE order_id = :order_id
	
    }
    

    if {$provider_id eq ""} {
	set provider_id 0
    }

    if {$incoterm_id eq ""} {
	set incoterm_id 0
    }


    ns_log Notice "
	-order_id $order_id \n
	-cnimp_number $cnimp_number \n
	-parent_id $parent_id \n
	-provider_id $provider_id \n
	-cnimp_date $cnimp_date \n
	-approval_date $approval_date \n
	-li_need_p $li_need_p \n
	-payment_date $payment_date \n
	-manufactured_date $manufactured_date \n
	-departure_date $departure_date \n
	-arrival_date $arrival_date \n
	-awb_bl_number $awb_bl_number \n
	-numerary_date $numerary_date \n
	-di_date $di_date \n
	-di_status $di_status \n
	-nf_date $nf_date \n
	-delivery_date $delivery_date \n
	-incoterm_id $incoterm_id \n
	-transport_type $transport_type \n
	-order_cost $order_cost \n
	-exchange_rate_type $exchange_rate_type \n
	-lc_number $lc_number \n
	-start_date $start_date \n
	-notes $notes "
       
    
    if {$cnimp_date ne ""} {
	set cnimp_date [template::util::date::from_ansi $cnimp_date [lc_get formbuilder_time_format]]
    }
    
    if {$approval_date ne ""} {
	set approval_date [template::util::date::from_ansi $approval_date [lc_get formbuilder_time_format]]
    }

    if {$payment_date ne ""} {
	set payment_date [template::util::date::from_ansi $payment_date [lc_get formbuilder_time_format]]
    }

    if {$manufactured_date ne ""} {
	set manufactured_date [template::util::date::from_ansi $manufactured_date [lc_get formbuilder_time_format]]
    }

    if {$departure_date ne ""} {
	set departure_date [template::util::date::from_ansi $departure_date [lc_get formbuilder_time_format]]
    }

    if {$arrival_date ne ""} {
	set arrival_date [template::util::date::from_ansi $arrival_date [lc_get formbuilder_time_format]]
    }

    if {$numerary_date ne ""} {
	set numerary_date [template::util::date::from_ansi $numerary_date [lc_get formbuilder_time_format]]
    }
    
    if {$di_date ne ""} {
	set di_date [template::util::date::from_ansi $di_date [lc_get formbuilder_time_format]]
    }

    if {$nf_date ne ""} {
	set nf_date [template::util::date::from_ansi $nf_date [lc_get formbuilder_time_format]]
    }

    if {$delivery_date ne ""} {
	set delivery_date [template::util::date::from_ansi $delivery_date [lc_get formbuilder_time_format]]
    }

    if {$start_date ne ""} {
	set start_date [template::util::date::from_ansi $start_date [lc_get formbuilder_time_format]]
    }    


} -new_data {
        
    
    set order_id [cn_import::order::new \
		      -cnimp_number $cnimp_number \
		      -parent_id $parent_id \
		      -provider_id $provider_id \
		      -cnimp_date $cnimp_date \
		      -approval_date $approval_date \
		      -li_need_p $li_need_p \
		      -payment_date $payment_date \
		      -manufactured_date $manufactured_date \
		      -departure_date $departure_date \
		      -arrival_date $arrival_date \
		      -awb_bl_number $awb_bl_number \
		      -numerary_date $numerary_date \
		      -di_date $di_date \
		      -di_status $di_status \
		      -nf_date $nf_date \
		      -delivery_date $delivery_date \
		      -incoterm_id $incoterm_id \
		      -transport_type $transport_type \
		      -order_cost $order_cost \
		      -exchange_rate_type $exchange_rate_type \
		      -lc_number $lc_number \
		      -start_date $start_date \
		      -notes $notes \
		      -creation_ip [ad_conn peeraddr] \
		      -creation_user [ad_conn user_id] \
		      -context_id [ad_conn package_id] \
		     ]
    
} -edit_data {

    ns_log Notice "
	-order_id $order_id \n
	-cnimp_number $cnimp_number \n
	-parent_id $parent_id \n
	-provider_id $provider_id \n
	-cnimp_date $cnimp_date \n
	-approval_date $approval_date \n
	-li_need_p $li_need_p \n
	-payment_date $payment_date \n
	-manufactured_date $manufactured_date \n
	-departure_date $departure_date \n
	-arrival_date $arrival_date \n
	-awb_bl_number $awb_bl_number \n
	-numerary_date $numerary_date \n
	-di_date $di_date \n
	-di_status $di_status \n
	-nf_date $nf_date \n
	-delivery_date $delivery_date \n
	-incoterm_id $incoterm_id \n
	-transport_type $transport_type \n
	-order_cost $order_cost \n
	-exchange_rate_type $exchange_rate_type \n
	-lc_number $lc_number \n
	-start_dateEDIT $start_date \n
	-notes $notes "
       

    
    cn_import::order::edit \
	-order_id $order_id \
	-cnimp_number $cnimp_number \
	-parent_id $parent_id \
	-provider_id $provider_id \
	-cnimp_date $cnimp_date \
	-approval_date $approval_date \
	-li_need_p $li_need_p \
	-payment_date $payment_date \
	-manufactured_date $manufactured_date \
	-departure_date $departure_date \
	-arrival_date $arrival_date \
	-awb_bl_number $awb_bl_number \
	-numerary_date $numerary_date \
	-di_date $di_date \
	-di_status $di_status \
	-nf_date $nf_date \
	-delivery_date $delivery_date \
	-incoterm_id $incoterm_id \
	-transport_type $transport_type \
	-order_cost $order_cost \
	-exchange_rate_type $exchange_rate_type \
	-lc_number $lc_number \
	-start_date $start_date \
	-notes $notes 
       

} -after_submit {
    ad_returnredirect $return_url
    ad_script_abort
}



