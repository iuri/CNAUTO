<?xml version="1.0"?>
<queryset>

    <fullquery name="newsletters::email::get_filtred.get_emails">
        <querytext>
	        select distinct nd.email 
			from newsletters_data nd, newsletters_emails ne 
			where nd.email = ne.email and ne.valid = 't'
			and ne.newsletter_id = :newsletter_id
			$email_where_clause
        </querytext>
    </fullquery>
</queryset>
