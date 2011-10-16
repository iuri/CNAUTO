<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="select_emails">
        <querytext>
	    select nd.email,
               data, field_id
        from newsletters_data nd,
             newsletters_emails ne
        where field_id in ([join $fields ,])
	    and  ne.newsletter_id = :newsletter_id
		and  ne.email = nd.email
        and ne.valid = 't'
        order by email, field_id

        </querytext>
    </fullquery>

</queryset>

