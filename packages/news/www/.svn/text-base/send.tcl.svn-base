ad_page_contract {


} {
	{item_id}
	{name}
	{texto}
	{email}
}


set package_id [ad_conn package_id]
set live_revision [db_string get_live_revision {select revision_id from cr_revisions where item_id = :item_id order by revision_id desc limit 1} -default ""]
set item_exist_p [db_0or1row one_item {}]

set package_url [apm_package_url_from_id $package_id]

set publish_body [db_string get_content "select  content
	from    cr_revisions
	where   revision_id = :live_revision"]
    
set lead [util_close_html_tags $publish_body "480" "480" "..." ""]
set title $publish_title

set html "
<html>
<body>
<style type=3D\"text/css\">
body {margin:0 auto; padding:0;}
img {border:0}
</style>	
<body>
<div>
		<table bgcolor=\"#FFFFFF\" border=\"0\" cellpadding=\"10\" cellspacing=\"15\" width=\"550\" align=\"center\">
  			<tbody><tr>
    			<td bgcolor=\"#F7F7F7\" valign=\"top\" align=\"left\"><img src=\"[ad_url]/resources/theme-mda/imagens/mdamain/logomin_gr.gif\"
 alt=\"Ministério do Desenvolvimento Agrário\" width=\"315\" height=\"25\">
    				<br>
    				<font face=\"Trebuchet MS, Arial, Verdana, Tahoma, sans-serif\" size=\"+1\">
    					<b>Notícias</b>
    				</font>
    			</td>
			</tr>
			<tr>
    			<td bgcolor=\"#F7F7F7\" valign=\"top\" align=\"left\">
					<font face=\"Trebuchet MS, Arial, Verdana, Tahoma, sans-serif\">
      					<h2>$title</h2>
	  					<p>$lead</p>
	  					<p><a href=\"[ad_url]${package_url}item?item_id=$item_id\" target=\"_blank\">Leia esta matária na Integra</a></p>
	  				</font>
				</td>
  			</tr>
  			<tr>
    			<td bgcolor=\"#F7F7F7\" valign=\"top\" align=\"left\" height=\"46\">
    				<font color=\"#006633\" face=\"Trebuchet MS, Arial, Verdana, Tahoma, sans-serif\" size=\"2px\">
    					$texto
						<br><br>        				<b>$name</b> te enviou esta matéria
        			</font>
        		</td>
  			</tr>
		</tbody></table>
	</div>

</div><br></body></html>"

set extra_headers [ns_set create]
set message_text ""
set message_data [build_mime_message $message_text $html utf-8]
ns_set put $extra_headers Content-Type [ns_set get $message_data Content-Type]
set message [ns_set get $message_data body]
	
acs_mail_lite::send -send_immediately -to_addr $email \
				-from_addr comunidades@mda.gov.br \
				-subject $title \
				-body $message \
                -extraheaders $extra_headers

