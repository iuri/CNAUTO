ad_page_contract {

    Add a new workflow step
} {
    {workflow_id}
    {pretty_name ""}
    {return_url ""}
}

cn_import::workflow::step::new \
    -workflow_id $workflow_id \
    -pretty_name $pretty_name 




ad_returnredirect $return_url
ad_script_abort