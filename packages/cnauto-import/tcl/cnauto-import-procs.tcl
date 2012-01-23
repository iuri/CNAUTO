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
