ad_page_contract {
    Change user locale

    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    @creation-date 2011-10-13
} {
    {locale ""}
    {return_url ""}
}


lang::user::set_locale -user_id [ad_conn user_id] -package_id [package_id] $locale 

ad_returnredirect $return_url