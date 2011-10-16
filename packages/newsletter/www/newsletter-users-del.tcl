ad_page_contract {
    
    Removes user form mailing list

    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    @creation-date 2011-07-04
} {
    {email:multiple ""}
    {newsletter_id ""}
    {return_url ""}
    
}

ns_log Notice "PAGE newsletter-user-del"
ns_log Notice "$email \n $newsletter_id \n $return_url"

set context_bar [list [list "newsletter-users?newsletter_id=$newsletter_id" "[_ newsletter.Newsletter_Information]"] "[_ newsletter.Delete_Users]"]


template::multirow create emails elem

foreach elem $email {
    template::multirow append emails $elem
}

ad_return_template

