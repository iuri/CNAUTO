ad_library {

    CN Auto Assurance API

}


namespace eval cn_assurance {}


ad_proc -public cn_assurance::get_color_options {} {

    Returns a list of lists to the ad_form select element 

} {

    return [db_list_of_lists select_colors { SELECT name, code FROM cn_colors }]
}