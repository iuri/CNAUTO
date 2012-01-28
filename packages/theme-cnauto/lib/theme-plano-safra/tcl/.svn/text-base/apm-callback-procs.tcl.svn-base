# packages/videos/tcl/install-procs.tcl

ad_library {

    Plano Safra Theme Install Library

    callback implementations for the pkg
    
    @author Iuri Sampaio (iuri.sampaio@gmail.com)
    @creation-date 2011-06-22
}


namespace eval plano_safra {}
namespace eval plano_safra::apm {}
namespace eval plano_safra::install {}

ad_proc -private plano_safra::apm::after_upgrade {
    {-from_version_name:required}
    {-to_version_name:required}
} {
    upgrade callback after upgrade

    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    @creation-date 2011-06-23
} {
  
    apm_upgrade_logic \
	-from_version_name $from_version_name \
	-to_version_name $to_version_name \
	-spec {
	    0.1d 0.1.d1 {
	    }
	}
} 



ad_proc -private  plano_safra::install::before_uninstall {} {

    Callback to remove Plano Safra's element configurations
    
    @author Iuri Sampaio
    @creation-date 2011-06-23

} {

    ns_log Notice "Runnin API plano_safra::install::before_uninstall"

    db_1row select_subsite_ids {
	SELECT node_id as subsite_node_id, object_id as subsite_package_id
	FROM site_nodes WHERE name = 'plano-safra'
    }
    
    # 1. Remove Plano Safra from New Portal
    set portal_id [db_string select_portal_id {
	SELECT portal_id FROM  portal_object_map WHERE object_id = :subsite_package_id
    }]

    portal::object_unmap -object_id $subsite_package_id
    
    db_exec_plsql delete_new_portal {
	SELECT portal__delete(:portal_id)
    }
    
    
    # 2. Remove Applications
    set sounds_node_id [db_string select_node_id {
	SELECT node_id FROM site_nodes WHERE parent_id = :subsite_node_id AND name = 'radiosafra'
    }]
    site_node::unmount -node_id $sounds_node_id
    site_node::delete -node_id $sounds_node_id


    set videos_node_id [db_string select_node_id {
	SELECT node_id FROM site_nodes WHERE parent_id = :subsite_node_id AND name = 'tvsafra'
    }]
    site_node::unmount -node_id $videos_node_id
    site_node::delete -node_id $videos_node_id

    set news_node_id [db_string select_node_id {
	SELECT node_id FROM site_nodes WHERE parent_id = :subsite_node_id AND name = 'news'
    }]
    site_node::unmount -node_id $news_node_id
    site_node::delete -node_id $news_node_id
    
    
    set xowiki_node_id [db_string select_node_id {
	SELECT node_id FROM site_nodes WHERE parent_id = :subsite_node_id AND name = 'xowiki'
    }]
    site_node::unmount -node_id $xowiki_node_id
    site_node::delete -node_id $xowiki_node_id


    set banners_node_id [db_string select_node_id {
	SELECT node_id FROM site_nodes WHERE parent_id = :subsite_node_id AND name = 'banners'
    }]
    site_node::unmount -node_id $banners_node_id
    site_node::delete -node_id $banners_node_id


    set pageflip_node_id [db_string select_node_id {
	SELECT node_id FROM site_nodes WHERE parent_id = :subsite_node_id AND name = 'pageflip'
    }]
    site_node::unmount -node_id $pageflip_node_id
    site_node::delete -node_id $pageflip_node_id


    # 3.  Remove Subsite
    site_node::unmount -node_id $subsite_node_id
    site_node::delete -node_id $subsite_node_id




    # 4. Remove Layout
    set layout_id [db_string select_layout {
	SELECT layout_id FROM portal_layouts
	WHERE name = '#theme-plano-safra.Plano_Safra_5_column#'
	AND description = '#theme-plano-safra.Plano_Safra_5_column#'
	AND resource_dir = '/resources/theme-plano-safra/css/plano-safra'
        AND filename = '../../theme-plano-safra/lib/layouts/plano-safra'
    }]
    
    db_exec_plsql drop_portal_layout {
	SELECT portal_layout__delete(:layout_id)
    }
    
    #5. Remove Theme
    set theme_id [db_string select_theme {
	SELECT theme_id FROM portal_element_themes 
        WHERE name = '#theme-plano-safra.Plano_Safra_Theme#'
	AND description = '#theme-plano-safra.Plano_Safra_Theme#'
	AND filename = '../../theme-plano-safra/lib/themes/plano-safra-theme'
	AND resource_dir = '../../theme-plano-safra/lib/themes/plano-safra-theme'
    }]

    
    db_dml delete_dotlrn_site_template {
	DELETE FROM dotlrn_site_templates
	WHERE portal_theme_id = :theme_id
    }

    db_exec_plsql drop_object {
	SELECT acs_object__delete(:theme_id);
    }

    #db_exec_plsql drop_portal_theme {
    #SELECT portal_element_theme_delete(:theme_id)
    #}    

}




ad_proc -private plano_safra::install::after_install {
    { -package_id "" }
} {
    Callback that runs APIs to setup Plano Safra's structure such as subsite, applications, theme and layout for the new-portal

    @author Iuri Sampaio
    @creation-date 2011-06-23

} {

    ns_log Notice "Running API plano-safra::apm::after_install"
    # --------------------------------------------------------
    # Creates Plano Safras Theme
    # --------------------------------------------------------
    set var_list [list \
		      [list name "#theme-plano-safra.Plano_Safra_Theme#"] \
		      [list description "#theme-plano-safra.Plano_Safra_Theme#"] \
		      [list filename ../../theme-plano-safra/lib/themes/plano-safra-theme] \
		      [list resource_dir ../../theme-plano-safra/lib/themes/plano-safra-theme]
		  ]
    
    set theme_id [package_instantiate_object -var_list $var_list portal_element_theme]
    
    set site_template_id [db_nextval acs_object_id_seq]

    db_dml insert_theme {}



    # --------------------------------------------------------
    # Creates Plano Safra's Layout
    # --------------------------------------------------------
    set var_list [list \
		      [list name "#theme-plano-safra.Plano_Safra_5_column#"] \
		      [list description "#theme-plano-safra.Plano_Safra_5_column#"] \
		      [list resource_dir /resources/theme-plano-safra/css/plano-safra] \
		      [list filename ../../theme-plano-safra/lib/layouts/plano-safra]
		  ]
    set layout_id [package_instantiate_object -var_list $var_list portal_layout]
    
    set var_list [list \
		      [list layout_id $layout_id] \
		      [list region 1]
		  ]
    package_exec_plsql -var_list $var_list portal_layout add_region

    set var_list [list \
		      [list layout_id $layout_id] \
		      [list region 2]
		  ]
    package_exec_plsql -var_list $var_list portal_layout add_region
    set var_list [list \
		      [list layout_id $layout_id] \
		      [list region 3]
		  ]
    package_exec_plsql -var_list $var_list portal_layout add_region
    set var_list [list \
		      [list layout_id $layout_id] \
		      [list region 4]
		  ]
    package_exec_plsql -var_list $var_list portal_layout add_region
    set var_list [list \
		      [list layout_id $layout_id] \
		      [list region 5]
		  ]
    package_exec_plsql -var_list $var_list portal_layout add_region


    ns_log Notice "$theme_id | $site_template_id | $layout_id"

    # --------------------------------------------------------
    # Mount Plano Safra's Subsite and applications under it
    # --------------------------------------------------------


    # Get Main Site's node_id
    set parent_node_id [db_string qry {
	SELECT node_id
	FROM site_nodes s, apm_packages p, acs_objects o
	WHERE p.package_key = 'acs-subsite'
	AND p.package_id = o.package_id
	AND s.object_id = o.object_id
	AND o.title = '#acs-kernel.Main_Site#'
    }]
    
    # Mounts Subsite Plano Safra
    set subsite_package_id [site_node::instantiate_and_mount \
				-parent_node_id $parent_node_id \
				-node_name "plano-safra" \
				-package_name "Plano Safra" \
				-package_key "acs-subsite"]
    
    set subsite_node_id [db_string select_node_id {
	SELECT node_id FROM site_nodes WHERE object_id = :subsite_package_id
    }]
    
    ns_log Notice "$parent_node_id | $subsite_node_id | $subsite_package_id"

    parameter::set_value -package_id $subsite_package_id -parameter "DefaultMaster" -value "/packages/theme-plano-safra/lib/plano-safra-master"


    set portal_id [db_exec_plsql create_new_portal {
	select portal__new(
			      null,
			         'Plano Safra',
			         :theme_id,
			         :layout_id,
			         null,
			         'Main Portal',
			         'M',
			         'portal',
			         now(),
			         null,
			         null,
			         :subsite_package_id
			      );
    }]
    
    portal::object_map -portal_id $portal_id -object_id $subsite_package_id

    
    # Mounts Sounds Appl
    set sounds_package_id [site_node::instantiate_and_mount \
			       -parent_node_id $subsite_node_id \
			       -node_name "radiosafra" \
			       -package_name "Radio Safra" \
			       -package_key "sounds"]

    
    # Mounts Sounds Appl
    set pageflip_package_id [site_node::instantiate_and_mount \
			       -parent_node_id $subsite_node_id \
			       -node_name "publicacoes" \
			       -package_name "Publicacoes" \
			       -package_key "pageflip"]


    # Mounts Videos Appl
    set videos_package_id [site_node::instantiate_and_mount \
			       -parent_node_id $subsite_node_id \
			       -node_name "tvsafra" \
			       -package_name "TV Safra" \
			       -package_key "videos"]

    parameter::set_value -package_id $videos_package_id -parameter "PortletTemplate" -value "/packages/theme-plano-safra/templates/video-mini-portlet"


#    videos_portal_portlet::add_self_to_page -portal_id $portal_id -package_id $videos_package_id -param_action overwrite   

#    set form [ns_getform]
#    set portal_id [ns_set get $form portal_id]
#    set return_url [ns_set get $form return_url]
#    set anchor [ns_set get $form anchor]
    
#    portal::configure_dispatch -portal_id $portal_id -form $form



    # Mounts Banners Appl
    set news_package_id [site_node::instantiate_and_mount \
			     -parent_node_id $subsite_node_id \
			     -node_name "news" \
			     -package_name "News" \
			     -package_key "news"]

    parameter::set_value -package_id $news_package_id -parameter "PortletTemplate" -value "/packages/theme-plano-safra/templates/news-portlet"


    # Mounts Banners Appl
    set banners_package_id [site_node::instantiate_and_mount \
				-parent_node_id $subsite_node_id \
				-node_name "banners" \
				-package_name "Banners" \
				-package_key "banners"]

    # Mounts Xowiki Appl
    set xowiki_package_id [site_node::instantiate_and_mount \
			       -parent_node_id $subsite_node_id \
			       -node_name "xowiki" \
			       -package_name "Xowiki" \
			       -package_key "xowiki"]

    
    parameter::set_value -package_id $xowiki_package_id -parameter "top_portlet" -value ""


}








ad_proc -private plano_safra::install::add_categories {
    {-package_id ""}
} {
    a callback install that adds standard tree, categories ans sub-categories related to audios
} {

    #create category tree
    set tree_id [category_tree::add -name audios_safra]
    
    set parent_id [category::add -tree_id $tree_id -parent_id [db_null] -name "Tipo" -description "Tipo de Audio"]
    category::add -tree_id $tree_id -parent_id $parent_id -name "Noticias" -description "Noticias"
    category::add -tree_id $tree_id -parent_id $parent_id -name "H. A. F." -description "Historias da Agricultura Familiar"
    category::add -tree_id $tree_id -parent_id $parent_id -name "A. Q. S." -description "O Agricultor quer saber"
    category::add -tree_id $tree_id -parent_id $parent_id -name "Spots" -description "Spots"
    
    set object_id [db_list select_object_id "
select object_id 
from acs_objects 
where object_type = 'apm_package' 
and package_id = $package_id
    "]

    category_tree::map -tree_id $tree_id -object_id $object_id
}




ad_proc -public plano_safra::new_sound_redirect {
} {

    Redirects to a new page to add sound item
} {

    ad_returnredirect [export_vars -base "/theme-plano-safra/www/sounds/sounds"
}