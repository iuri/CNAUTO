ad_page_contract {
    Change assurance status
} {
    {assurance_id}
    {status}
    {return_url ""}
}


cn_assurance::change_status -assurance_id $assurance_id -status $status


ad_returnredirect [export_vars -base $return_url {assurance_id}]