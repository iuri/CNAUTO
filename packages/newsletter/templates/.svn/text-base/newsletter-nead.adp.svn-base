<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<body style="margin:0px;background-color:#F0ECE0">
<style type=3D"text/css">
body {margin:0 auto; padding:0;}
img {border:0}
* {margin:0px}
</style>	
<div id="main" style="margin: 0 auto; width:810px; background-color:#FFFFFF;padding:0;">
	<div id="topo"><img style="margin:0px;margin-bottom:-4px;" src="@site_url@/resources/newsletter/nead/images/topo.jpg" alt="Boletim Eletrônico" border="0" /> <h6 style="background-color:#3B2B1C;color:#FFFFFF;float:right;font-family:Arial,Helvetica,sans-serif;font-size:11px;height:25px;margin:0;padding:12px;text-align:right;width:786px;"> <img src="@site_url@/resources/newsletter/nead/images/noticias-agrarias.jpg" style="margin-right: 463px;"> <span style="margin-top:8px;float:right">Nº@item_number@, Brasília (DF), @date@</span></h6></div>
	
	<div id="conteudo" style="width:779px; background-color:#FFFFFF; margin:0 0 12px 10px;">
		<multiple name="get_news_items">
		<table id="box-posts" style="clear: both;padding: 20px 10px;border-bottom:2px dashed #E4E4E4;">
		    <tr>
			<if @get_news_items.image_id_size_2@ not nil>
			<td style="width: 140px;float: left;margin-right: 8px;"><a href="@site_url@@get_news_items.url@item?item_id=@get_news_items.item_id@"><img class="border-img" style="padding:1px;background:#FFF;border:1px solid #CCC;" src="@site_url@@get_news_items.url@image/@get_news_items.image_id_size_2@" alt=""  width="130px"/></a></td></if>
			<td style="font-family:Arial, Helvetica, sans-serif;font-size: 17px;margin:5px 0 0;"><h2 style="font-family:Arial, Helvetica, sans-serif;font-size: 17px;margin:5px 0 0;"><a style="color: #BF6006;padding: 10px 0 0 0;margin:5px 0 0; text-decoration:none;" href="@site_url@@get_news_items.url@item?item_id=@get_news_items.item_id@" target="_blank">@get_news_items.publish_title@</a></h2>
			<p style="font-family:Arial, Helvetica, sans-serif; font-size: 11px;color: #333;">@get_news_items.publish_body404@</p>
			</td>
		   </tr>
		</table>
		</multiple>
	</div>

	<table id="links" style="color:#666666; text-decoration:none; font-family:Arial, Helvetica, sans-serif; font-size:12px;margin-left:15px;">
		<tr>
			<td>
				<if @@favoritos_texto_width@ not eq 0>
				<table id="favoritos" style="color:#666666; text-decoration:none; font-family:Arial, Helvetica, sans-serif; font-size:12px; width:@box_width@;float:left;margin-right:15px" cellspacing="0">
					<tr>	
						<td style="background-color:#3B2B1C;height:35px;font-family:Arial, Helvetica, sans-serif;font-size: 17px;color:#fff;text-align:center;">
								Favoritos
						</td>
					</tr>
					<tr>	
						<td style="margin-top: -3px; border: 1px solid #F0ECE0; padding: 7px; text-decoration: none;font-size:15px;">
							<a href="@linkfavoritos@" style="color: #BF6006;padding: 10px 0 0 0;margin:5px 0 0; text-decoration:none;" target="_blank">@favoritos_texto@</a>
						</td>
					</tr>
				</table>
				</if>
				<if @textoculturadigital_width@ not eq 0>
				
				<table id="culturadigital" style="color:#666666; text-decoration:none; font-family:Arial, Helvetica, sans-serif; font-size:12px;width:@box_width@;float:left;margin-right:15px" cellspacing="0">
					<tr>	
						<td style="background-color:#3B2B1C;height:35px;font-family:Arial, Helvetica, sans-serif;font-size: 17px;color:#fff;text-align:center;">
								Cultura
						</td>
					</tr>
					<tr>	
						<td style="margin-top: -3px; border: 1px solid #F0ECE0; padding: 7px; text-decoration: none;font-size:15px;">
							<a href="@linkculturadigital@" style="color: #BF6006;padding: 10px 0 0 0;margin:5px 0 0; text-decoration:none;" target="_blank">@textoculturadigital@</a>
						</td>
					</tr>
				</table>
				</if>
				<if @agenda_texto_width@ not eq 0>
				<table id="culturadigital" style="color:#666666; text-decoration:none; font-family:Arial, Helvetica, sans-serif; font-size:12px;width:@box_width@;float:left;" cellspacing="0">
					<tr>	
						<td style="background-color:#3B2B1C;height:35px;font-family:Arial, Helvetica, sans-serif;font-size: 17px;color:#fff;text-align:center;">
								Agenda
						</td>
					</tr>
					<tr>	
						<td style="margin-top: -3px; border: 1px solid #F0ECE0; padding: 7px; text-decoration: none;font-size:15px;">
							<a href="@agenda_link@" style="color: #BF6006;padding: 10px 0 0 0;margin:5px 0 0; text-decoration:none;" target="_blank">@agenda_texto@</a>
						</td>
					</tr>
				</table>
				</if>
	
			</td>
		</tr>
	</table>


	<table id="rodape" style="color:#999999; text-decoration:none; padding:10px 0 0 0; font-family:Arial, Helvetica, sans-serif; font-size:12px;">
		<tr><td><strong>Núcleo de Estudos Agrários e Desenvolvimento Rural -SBN - Quadra 02, Bloco D, Lote 16, Loja 10 - Ed. Sarkis, 2º Subsolo - Asa Norte - Brasilia/DF - Cep: 70.040-910
		</td></tr>
	</table>
	<p style="font-size:13px;color:#666;margin-left:3px;"><strong>Caso não queira mais receber este boletim <a href="@site_url@@package_url@newsletter-cancel?newsletter_id=@newsletter_id@">clique aqui</a></strong></p>
<!-- Fim Estrutura -->
</div>
</body>
</html>
