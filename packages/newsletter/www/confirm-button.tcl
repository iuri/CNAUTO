ad_page_contract {
} -properties {
    __form_contents__:multirow
}

set __return_url__ [ad_conn url]

# The basic idea here is to build a multirow holding the form contents, which then get
# passed back to the form handler transparently as a submission, as though the confirm
# step never happened.

# There's one exception - we set the special form element "__confirmed_p" true.  This
# informs ad_form that the user has indeed confirmed the submission.

multirow create __form_contents__ __key__ __value__

if { ![empty_string_p [set __form__ [ns_getform]]] } {

    set __form_size__ [ns_set size $__form__]
    set __form_counter__ 0
   
    while { $__form_counter__ < $__form_size__ } {
        if { [string equal [ns_set key $__form__ $__form_counter__] __confirmed_p] } {
            multirow append __form_contents__ __confirmed_p 1
        } else {

	    set __key__ [ns_set key $__form__ $__form_counter__]
	    set __values__ [ns_querygetall $__key__]

	    foreach __value__ $__values__ {
		multirow append __form_contents__ $__key__ $__value__
		lappend $__key__ $__value__
	    }

        }
        incr __form_counter__
    }
    
   

}


 set fields_list [newsletters::fields::get_list -newsletter_id $newsletter_id]

foreach field $fields_list {
	util_unlist $field field_id field_name
	set var_name "option_${field_id}"
		if {[value_if_exists $var_name] != ""} {
			lappend fields_data_list [list $field_id [value_if_exists $var_name]]
		}
   }
    set email_list [newsletters::email::get_filtred -fields_data_list $fields_data_list -newsletter_id $newsletter_id]
    set lista_de_emails ""
    set qtd [llength $email_list]
	if {$qtd < 50} {
		set lista_de_emails [join $email_list <br>]
	}
	
	set qtd_total [db_string select_emails	"select count(*) as qtd
			from newsletters_emails ne 
			where ne.valid = 't'
			and ne.newsletter_id = :newsletter_id" -default 0]
