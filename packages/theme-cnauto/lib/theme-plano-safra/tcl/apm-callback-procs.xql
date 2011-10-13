
<?xml version="1.0"?>

<queryset>

  <fullquery name="plano_safra::install::after_install.insert_theme">
    <querytext>
      INSERT INTO dotlrn_site_templates
        (site_template_id, pretty_name, site_master, portal_theme_id ) 
      VALUES
        (:site_template_id, '#theme-plano-safra.Plano_Safra_Theme#', '/packages/theme-plano-safra/lib/plano-safra-master', :theme_id)
    </querytext>
  </fullquery>
    
</queryset>
