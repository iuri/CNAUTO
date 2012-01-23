ad_library {
    
    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    @cretion-date 2012-01-21
    
}


namespace eval cn_import {}
namespace eval cn_import::incoterm {}


ad_proc -public cn_import::incoterm::new {
    {-name ""}
    {-pretty_name ""}
} {

    Adds a new incoterm
} {

    set incoterm_id [db_nextval acs_object_id_seq]
	

    db_dml insert_incoterm {
	INSERT INTO cn_import_incoterms (
	    incoterm_id,
	    name,
	    pretty_name
        ) VALUES (
		  :incoterm_id,
		  :name,
		  :pretty_name
	)
    }

    return 
}



ad_proc -public cn_import::get_provider_options {} {
    Returns a list of providers for a seletc widget
} {

    
    

    set providers [db_list_of_lists select_providers {
	SELECT cp.pretty_name, cp.person_id 
	FROM cn_persons cp, cn_categories cc 
	WHERE cp.type_id = cc.category_id AND cc.name = 'fornecedoresdoexterior';
    }]

    lappend providers "{#cn-import.Select_providers#} 0"

    ns_log Notice "$providers"

    return $providers
}