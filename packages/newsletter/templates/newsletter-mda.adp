<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<body style="margin:0px;background-color:#F0ECE0">
<style type=3D"text/css">
body {margin:0 auto; padding:0;}
img {border:0}
* {margin:0px}
</style>	
<div id="main" style="margin: 0 auto; width:810px; background-color:#FFFFFF;padding:0;">
	<div id="topo"><img style="margin:0px;margin-bottom:-4px;" src="@site_url@/resources/newsletter/mda/images/topo.jpg" alt="Boletim Eletrônico" border="0" /> <h6 style="color:#666;font-family:Arial,Helvetica,sans-serif;font-size:11px;height:13px;margin:0;padding:7px;width:786px;"> <span style="margin-top:8px;">Brasília (DF), @date@</span></h6></div>
	
	<div id="conteudo" style="width:779px; background-color:#FFFFFF; margin:0 0 12px 10px;">










		<multiple name="get_news_items">
			<if @num_news_items@ gt 1>

			   <table id="box-posts" style="clear: both;padding: 20px 10px;border-bottom:2px dashed #E4E4E4;">
			    <tr>
				<if @get_news_items.image_id_size_2@ not nil>
				<td style="width: 140px;float: left;margin-right: 8px;"><a href="@site_url@@get_news_items.url@item?item_id=@get_news_items.item_id@"><img class="border-img" style="padding:1px;background:#FFF;border:1px solid #CCC;" src="@site_url@@get_news_items.url@image/@get_news_items.image_id_size_2@" alt=""  width="130px"/></a></td></if>
				<td style="font-family:Arial, Helvetica, sans-serif;font-size: 17px;margin:5px 0 0;"><h2 style="font-family:Arial, Helvetica, sans-serif;font-size: 17px;margin:5px 0 0;"><a style="color: #666;padding: 10px 0 0 0;margin:5px 0 0; text-decoration:none;" href="@site_url@@get_news_items.url@item?item_id=@get_news_items.item_id@" target="_blank">@get_news_items.publish_title@</a></h2>
				<p style="font-family:Arial, Helvetica, sans-serif; font-size: 11px;color: #333;">@get_news_items.publish_body404@</p>
				</td>
			   	</tr>
			   </table>
			</if>
			<if @num_news_items@ eq 1>
				<table style="clear: both;padding: 20px 10px;border-bottom:2px dashed #E4E4E4;" id="box-posts">
		    		<tr>
						<td style="float: left; margin-right: 8px; width: 736px;">
						  <if @get_news_items.image_id@ not nil>
								<a href="@site_url@@get_news_items.url@item?item_id=@get_news_items.item_id@"><img width="300px" class="border-img" style="padding: 1px; background: none repeat scroll 0% 0% rgb(255, 255, 255); border: 1px solid rgb(204, 204, 204); float: left; margin-right: 15px;" src="@site_url@@get_news_items.url@image/@get_news_items.image_id@"></a>
						  </if>
						  <h2 style="font-family:Arial, Helvetica, sans-serif;font-size: 17px;margin:5px 0 17px;"><a style="color: #666;padding: 10px 0 0 0;margin:5px 0 0; text-decoration:none;" href="@site_url@@get_news_items.url@item?item_id=@get_news_items.item_id@" target="_blank">@get_news_items.publish_title@</a></h2>
							@get_news_items.publish_body_html;noquote@
						</td>
		   			</tr>
				</table>
			</if>

		</multiple>














	</div>

	<table id="rodape" style="color:#999999; text-decoration:none; padding:10px 0 0 0; font-family:Arial, Helvetica, sans-serif; font-size:12px;">
		<tr><td><strong>Portal do Ministério do Desenvolvimento Agrário Esplanada dos Ministérios, Bloco A/Ala Norte - CEP 70050-902 - Brasília-DF 
		</td></tr>
	</table>
	<p style="font-size:13px;color:#666;margin-left:3px;"><strong>Caso não queira mais receber este boletim <a href="@site_url@@package_url@newsletter-cancel?newsletter_id=@newsletter_id@">clique aqui</a></strong></p>
<!-- Fim Estrutura -->
</div>
</body>
</html>
