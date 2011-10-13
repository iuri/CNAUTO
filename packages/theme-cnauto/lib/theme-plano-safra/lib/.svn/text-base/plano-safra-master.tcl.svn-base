ad_page_contract {

    Master template for Plano Safra's Theme
}


set user_id [ad_conn user_id]
set untrusted_user_id [ad_conn untrusted_user_id]


if {![exists_and_not_null title]} {
    set title [ad_system_name]
}

if { ![info exists header_stuff] } {
    set header_stuff ""
}



# Subsite Info
subsite::get -array subsite_info

set subsite_url "/plano-safra/"
set new_portal_url [site_node::get_package_url -package_key new-portal]
set return_url [ad_return_url]


if {[string equal [ad_conn url] $subsite_info(url)]} {
    set content_p 1
} else {
    set content_p 0
}

set sw_admin_p [acs_user::site_wide_admin_p -user_id [ad_conn user_id]]

set portal_id [portal::get_mapped_portal -object_id $subsite_info(package_id)]


if {$portal_id != ""} {

    append header_stuff [portal::get_page_header_stuff \
			          -portal_id $portal_id \
			     -page_num 0]
    
    
    
    db_1row select_portal {} -column_array portal

    set page_id $portal(page_id)

    db_foreach select_element {} -column_array entry {
	# put the element IDs into buckets by region...
	lappend element_ids($entry(region)) $entry(element_id)
    } if_no_rows {
	set element_ids {}
    }
    
    
    
    
    set element_list [array get element_ids]
    
    # set up the template, it includes the layout template,
    # which in turn includes the theme, then elements
    set element_src "/packages/new-portal/www/render_styles/individual/render-element"



    append header_stuff [portal::get_page_header_stuff \
                            -portal_id $portal_id \
			     -page_num 0]



}


append header_stuff [subst {
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="author" content="Iuri Sampaio (iuri.sampaio@iurix.com" />
    <meta name="description" content="Plano Safra's Theme" />
    <meta name="keywords" content="" />
    <meta name="robots" content="All" />
    <title>Plano safra da agricultura familiar 2011 / 2012 - A agricultura familiar alimenta o brasil que cresce - </title>

    <script src="/resources/theme-plano-safra/js/jquery.js" type="text/javascript"></script>
    <script src="/resources/theme-plano-safra/js/main.js" type="text/javascript"></script>

<style type="text/css">

*{margin:0; padding:0;}

h1{ color: #9A6704 !important; font-family: Arial,Verdana,sans-serif; font-size: 18px; margin: 0 0 20px 0; }
h2{ font-family: Arial, Verdana, sans-serif; font-size:14px; color:#333333;}
h3{font-family:  Arial, Verdana, sans-serif; font-size:14px; color:#074D21;}
h4{font-family: Arial, Verdana, sans-serif; font-size:20px; color:#496D1D; padding:25px 0 5px 10px; list-style:none;}
h5{font-family: Arial, Verdana, sans-serif; font-size:18px; color:#496D1D; padding:35px 0 5px 10px;}

/* Div Barra do Governo  */
#barra-brasil-v2-exp {width: 1008px; height: 36px;float: none;clear: right; margin:0 auto; padding: 0;}
#barra-brasil-v2-exp img {border: 0;}
#barra-brasil-v2-exp.gif {background: url(/resources/theme-plano-safra/images/gif/barra-gov-bv2-dir.gif) no-repeat right top;}
#barra-brasil-v2-exp.gif .divCentro {background: url(/resources/theme-plano-safra/images/gif/barra-gov-bv2-centro.gif) no-repeat right top #074d21;}
#barra-brasil-v2-exp .divEsq {float:left;}
#barra-brasil-v2-exp .divCentro {margin-left: 16px;margin-right: 15px;width: auto;height: 36px;}
#barra-brasil-v2-exp #logo-republica-bv2 {display: block;float: left;margin: 0;padding: 6px 0 0 14px;}
#barra-brasil-v2-exp #logo-gov-bv2 {display: block;float: right;margin: 0;padding: 5px 6px 0 0;}
/* Fecha Div Barra do Governo  */

/* Div Main - Header - Midia Social  */
#main{ margin:0 auto; width:1008px; height:1130px; background:url(/resources/theme-plano-safra/images/background.jpg); background-repeat:repeat-x; border-left:#eeeeee 1px solid; border-right:#eeeeee 1px solid;}
#header{ width:1024px; height:60px;}
#midia-social {  float: right;  height: 25px; margin-right: -81px; margin-top: 30px;}
/* Fecha Div Main - Header - Midia Social  */

/* Div Menu - Navegação  */
#menu_navegacao { width:100%; height:32px; background:url(/resources/theme-plano-safra/images/menu-background.gif) repeat-x left; text-align:left; padding-top:18px; list-style:none; margin-bottom:10px;}
#menu_navegacao ul { margin-left:145px;}
#menu_navegacao li { display:inline; margin:0 8px; font-family:  Arial, Verdana, sans-serif; font-size:14px; color:#666666; list-style:none;}
#menu_navegacao li a { color:#5b5b5b; text-decoration:none; list-style:none;}
#menu_navegacao a:hover { color:#bebebe; text-decoration:none; }
/* Fecha Div Menu - Navegação  */

/* Div Destaque */
#box-destaque{ width:1004px; height:205px; background:url(/resources/theme-plano-safra/images/fundo-box.png) no-repeat;} 
#menu-vertical{ float:right;}
#menu-vertical ul{ width:195px; margin: 30px 10px 0 0; padding:0; list-style:none; background-color:#E1EACC; }
#menu-vertical ul li { border-bottom:1px dotted #496D1D; font-family: Arial, Verdana, sans-serif; font-size:12px; color:#496D1D;  padding: 4px 2px 5px 5px; }
#menu-vertical ul li a { text-decoration:none; color:#333;}
#menu-vertical li a:hover { color:#986B1F;}

 
#destaque{ width: 745px; height:168px; }
#destaque-foto { width:220px; height:155px; float:left; margin:15px 10px 0 10px; }
.destaque-titulo { width:740px; height: 25px; font-family: Arial, Verdana, sans-serif; font-size:16px; color:#496D1D; display:inline;}
.destaque-conteudo{ width:740px; height:100px; font-family: Arial, Verdana, sans-serif; font-size:13px; text-align: justify;color:#303335; letter-spacing:0; line-height:18px; display:inline;padding-top:5px;}
.destaque-conteudo a{font-family:Arial, Verdana, sans-serif; font-size:13px; color:#303335; letter-spacing:0; line-height:18px; text-decoration:none;}
.destaqueprincipal { color: #496D1D  !important; font-family: Arial,Verdana,sans-serif !important; font-size: 18px !important; line-height: 18px !important;}


/* Fecha Div Destaque  */


/* Div Content - Tv - Radio - Noticia - Publicações  */
#box-content{ margin: 0 auto; width:1004px; height:410px; }
.left-content  { margin-left: 5px;}
.main-content  { margin-left: 5px;}



#tv{ width:200px; height:265px; float:left; }
#box-tv a {  color: #496D1D;  font-family: arial;text-decoration: none;}
#box-tv p {color: #333333;font-size: 14px; padding: 26px 0 5px 10px; text-align: left;}
#box-tv { -moz-border-radius: 5px 5px 5px 5px; background-color: #e9e9e9; height: 312px; width: 188px;}
#box-frame-tv { width:167px; height:158px; padding:5px 0 0 10px;}



#radio{ width:800px; height:190px; float:left; border-bottom:#CCCCCC 1px dotted; margin:0 0 10px 0;}
#radio li{ display:inline; float:left; padding:0 5px 0 15px; margin:0 0 0 0; position:relative;}
#radio a{ list-style:none; text-decoration:none; color:#999999;}
#radio a span {display: none;}
#radio a:hover span {position: absolute;top:-80px;left: -5px; display: block; width: 190px; height:55px; padding: 10px; margin-left:2px; color: #264D62; background: #f1f1f1 url(/resources/theme-plano-safra/images/fundo-balao.jpg); font-size: 11px; font-family:Arial, Helvetica, sans-serif;text-align:left;border:1px solid #E0E0E0;}
.sounds_title {color: #496D1D;  font-family: arial;font-size: 16px;}
.sounds_description {  font-family: arial !important; font-size: 14px !important;}


#noticia{ width:496px; height:216px; float:left; }
.box-noticia-posts {border-bottom: 1px dotted #CCCCCC;clear: both; margin-left: 15px;  width: 472px;}
.box-noticia-posts h3 { color: #496D1D; font-family: Arial,Verdana,sans-serif;  font-size: 14px;  margin-top: 10px;}
.box-noticia-posts h3 a { color: #496D1D; font-family: Arial,Verdana,sans-serif;  font-size: 14px;  margin-top: 10px;}
.box-noticia-posts h2 a {color: #336655; text-decoration:none;}
.box-noticia-posts p { border-bottom: 1px dotted #CCCCCC; color: #303335; font-family: Arial,Verdana,sans-serif; font-size: 14px; letter-spacing: 0; line-height: 18px; padding: 10px 0;}
.box-noticia-posts a {color: #333333; text-decoration:none;}
.data_noticia { border: none !important;}
.titulo_noticias_listagem { font-size: 14px !important;}
.titulo_noticias_listagem h2 {font-size: 14px !important;}
.titulo_noticias_listagem {  font-size: 14px !important;}
#news_main p { padding-bottom: 0.5em !important; line-height: none !important;}
.maisnot li a {  color: #333333; font: 13px/1.33em Arial;  text-decoration: none;}

div.list-paginator-top { display: none !important;}

#publicacao{ width:300px; height:216px; float:right;}
#publicacao img{ margin:0 0 20px 0;}
#publicacao a{ border:0;}
.newsImage { width: 279px !important;}
#boxescontrel { width: 774px !important;}
#contrel { width: 200px !important;}
.data_noticia p {background: none repeat scroll 0 0 #235C96; background-color:#496D1D !important;}
.data_noticia {display: block; height:45px; border:#CCCDDB dotted 1px;float: left; margin-right: 15px; margin-top: 4px; text-align: center; width: 78px;  color:#FFFFFF; font-family:Arial, Helvetica, sans-serif; font-size:15px;}
.titulo_noticias_listagem { font-family:Arial, Helvetica, sans-serif; font-size:15px; text-decoration:none;}
h2 { padding:5px 0 0 0; font-family:Arial, Helvetica, sans-serif; font-size:15px; color:#FF0000; text-decoration:none;}
h2 a { text-decoration:none; color:#496D1D;}
p a{ text-decoration:none; color:#333333; }
img {border:none;}
.listagem_noticia { margin-left: 22px !important;   width: 95% !important;}
.news_full { padding-left: 20px !important;}
.titulo_noticias_listagem p {margin-left: 94px;}
.topo_listagem_noticia { text-align: justify; width: 902px;}


/* Fecha Div Content - Tv - Radio - Noticia - Publicações  */


/* Div Footer */

#footer{margin-top:40px; width:1008px; height:380px; float:left; background:url(/resources/theme-plano-safra/images/footer-bkg.jpg) no-repeat;}
#footer p { font-family:  Arial, Verdana, sans-serif; font-size:14px;color:#FFFFFF; text-align:center; margin-top:10px;}
#footer li { list-style:none; float:left; display:inline;}
#footer a{text-decoration:none;color:#f30;    }
#footer img{border:none; float:left;}
#footer ul,li{margin:0;padding:0;}
#preview{position:absolute;padding:5px;display:none;color:#fff;}
.one{ width:171px; margin:0;}
.two{width:142px; margin:0;}
.three {width:172px;  margin:0; }
.footer-text { background: none repeat scroll 0 0 #526721;color: #FFFFFF;font-family: Arial,Verdana,sans-serif;font-size: 14px;height: 45px;margin-top: 333px; text-align: center; width: 1008px;}
/* Fecha Div Footer */

</style>



}]





set doc(title) $title
set user_id [ad_conn user_id]
set subsite_admin_p [permission::permission_p \
			 -object_id [subsite::get_element -element object_id] \
			  -privilege admin \
			 -party_id $user_id]

if { $subsite_admin_p  } {
    set admin_url "[subsite::get_element -element url]admin/"
    set portal_datasources [portal::list_datasources $portal_id]
    set all_datasources [portal::list_datasources]
    
    
    set subsite_node_id $subsite_info(node_id)

    db_multirow  -extend {available} applications select_applications {} {
	if {[acs_user::site_wide_admin_p]} {
	    switch $package_key {
		file-storage {set package_key fs}
	    }
	        
	    foreach datasource $all_datasources {
		set package_portlet_key [lindex [split $package_key "_"] 0]
		if {[lsearch [split $datasource "_"] $package_portlet_key] != -1 && [lsearch $portal_datasources $datasource] == -1} {
		        set available "1"
		}
	    }
	}
	
    }
}
