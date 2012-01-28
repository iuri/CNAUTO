ad_page_contract {
  
}



template::list::create \
    -name categories \
    -multirow categories \
    -elements {
	pretty_name {
	    label "[_ cnauto-core.Name]"
	}
	object_type {
	    label "[_ cnauto-core.Name]"
	}	
   }



db_multirow -extend {} categories select_categories {
    SELECT pretty_name, object_type FROM cn_categories 

}

