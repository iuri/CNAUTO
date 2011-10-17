ad_page_contract {

    Policy News
    

    @author Alessandro Landim (alessandro.landim@teknedigital.com.br)
    @creation-date October 4, 2006
    @cvs-id $Id: policy.tcl,v 1.1 2006/10/10 15:04:15 alessandrol Exp $
} {
  {return_url "."}
  policy
}

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]


parameter::set_value -package_id $package_id -parameter ApprovalPolicy -value $policy
ad_returnredirect $return_url


