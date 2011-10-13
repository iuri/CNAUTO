<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<body>
<style type=3D"text/css">
body {margin:0 auto; padding:0;}
img {border:0}
</style>	
<div id="main" style="margin: 0 auto; width:810px; background-color:#e6e6e6;padding:0;">
	<div id="topo"><img src="@site_url@/resources/newsletter/conjur/topo.jpg" alt="Boletim Eletrônico" border="0" /> <h6 style="width:248px;  float:right; font-family:Arial, Helvetica, sans-serif; font-size:11px;padding:0"> Nº@item_number@, Brasília (DF), @date@</h6></div>
	
	<div id="conteudo" style="width:779px; background-color:#FFFFFF; margin:0 0 12px 10px;">
		<multiple name="get_news_items">
		<table id="box-posts" style="clear: both; width: 730px;padding: 20px 10px;border-bottom:1px dotted #E4E4E4;">
		    <tr>
			<if @get_news_items.image_id_size_2@ not nil>
			<td style="width: 140px;float: left;margin-right: 8px;"><a href="@site_url@@get_news_items.url@item?item_id=@get_news_items.item_id@"><img class="border-img" style="padding:1px;background:#FFF;border:1px solid #CCC;" src="@site_url@@get_news_items.url@image/@get_news_items.image_id_size_2@" alt=""  width="130px" height="88px"/></a></td></if>
			<td style="font-family:Arial, Helvetica, sans-serif;font-size: 12px;margin:5px 0 0;"><h2 style="font-family:Arial, Helvetica, sans-serif;font-size: 12px;margin:5px 0 0;"><a style="color: #333;padding: 10px 0 0 0;margin:5px 0 0; text-decoration:none;" href="@site_url@@get_news_items.url@item?item_id=@get_news_items.item_id@">@get_news_items.publish_title@</a></h2>
			<p style="font-family:Arial, Helvetica, sans-serif; font-size: 11px;color: #333;">@get_news_items.publish_body404@</p>
			</td>
		   </tr>
		</table>
		</multiple>
	</div>

	<table id="rodape" style="color:#79add2; text-decoration:none; padding:10px 0 0 0; font-family:Arial, Helvetica, sans-serif; font-size:12px;">
		<tr><td><strong>Consultoria Jurídica Junto ao Ministério do Desenvolvimento Agrário | <a href="">conjur@mda.gov.br</a> </strong><br/>
		<strong>Caso deseje não receber mais este boletim <a href="@site_url@@package_url@newsletter-cancel?newsletter_id=@newsletter_id@&email=@email@">clique aqui</a></strong>
		</td></tr>
	</table>

<!-- Fim Estrutura -->
</div>
</body>
</html>
