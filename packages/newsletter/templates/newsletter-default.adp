<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="pt-br" lang="pt-br">
<head>
<title>Boletim Eletrônico - CONJUR</title>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<style type="text/css">
body {margin:0; padding:0;}
#main {width:810px; height:660px; background-color:#e6e6e6;}
#topo{ width:779px; height:140px;}
#conteudo{ width:779px; height:430px; background-color:#FFFFFF; margin:0 0 12px 10px;}
#rodape {width:779px; height:40px;  background-color:#FFFFFF; margin:0 0 0 10px; text-align:center; text-decoration:none; padding:10px 0 0 0; font-family:Arial, Helvetica, sans-serif; font-size:12px; color:#666666}
#rodape a{color:#79add2; text-decoration:none; padding:10px 0 0 0; font-family:Arial, Helvetica, sans-serif; font-size:12px; }
.box-posts {clear: both; width: 730px;padding: 20px 10px;border-bottom:1px dotted #E4E4E4;}
.box-posts span{margin:0 0 10px;height:30px;font-size:11px;color:#000;} 
.box-posts span a{text-decoration:none;color:#000;}
.border-img{padding:1px;background:#FFF;border:1px solid #CCC; }
.box-posts .cat-img {width: 140px;float: left;margin-right: 8px;}
.box-posts .cat-img h3 a {text-transform: uppercase;color: #15576D;font-size: 9px;}
.box-posts h2 {font-family:Arial, Helvetica, sans-serif;font-size: 12px;padding: 10px 0 0 0;margin:5px 0 0;}
.box-posts h2 a {color: #333;padding: 10px 0 0 0;margin:5px 0 0; text-decoration:none;}
.box-posts h2 a:hover {color: #333;padding: 10px 0 0 0;margin:5px 0 0; text-decoration:underline;}
.box-posts p {font-family:Arial, Helvetica, sans-serif; font-size: 11px;padding:0 5px 5px 5px;color: #333;}
.box-posts p a {color: #333;text-decoration:none;}
.box-posts p a:hover {color: #333;}
</style>	
</head>
<body>
<!-- Inicio estrutura  -->
<div id="main">
	<div id="topo"><img src="@site_url@/resources/newsletters/conjur/topo.jpg" alt="Boletim Eletrônico" border="0" /> </div>
	
	<div id="conteudo">
		<multiple name="get_news_items">
		<div class="box-posts">
			<div class="cat-img"><a href="@site_url@@get_news_items.url@item?item_id=@get_news_items.item_id@"><img class="border-img" src="@site_url@@get_news_items.url@image/@get_news_items.image_id_size_2@" alt=""  width="130px" height="88px"/></a></div>
			<h2><a href="@site_url@@get_news_items.url@item?item_id=@get_news_items.item_id@">@get_news_items.publish_title@</a> </h2>
			<p>@get_news_items.publish_body180@</p>

		</div>
		</multiple>
	</div>

	<div id="rodape">
		<strong>Consultoria Jurídica Junto ao Ministério do Desenvolvimento Agrário | <a href="">conjur@mda.gov.br</a> </strong><br/>
		<strong>Caso deseje não receber mais este boletim <a href="#">clique aqui</a></strong>
	</div>

<!-- Fim Estrutura -->
</div>
</body>
</html>
