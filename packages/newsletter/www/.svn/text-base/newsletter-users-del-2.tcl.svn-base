#/packages/newsletter/www/newsletter-users-del-2.tcl
ad_page_contract {
    Delete newsletter users.

    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    @creation-date 2011-07-04
} {
    email:notnull
    {newsletter_id ""}
    {return_url ""}
    {cancel.x:optional}
}

if {![info exists cancel.x]} {

    
    foreach element $email {    
	db_dml delete_user {
	    DELETE FROM newsletters_data where email = :element
	}

	db_dml delete_user2 {
	    DELETE FROM newsletters_emails WHERE email = :element AND newsletter_id = :newsletter_id
	}

    }
}
ad_returnredirect $return_url



