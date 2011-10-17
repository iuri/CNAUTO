<master>
<property name="header_stuff">
	<link rel="stylesheet" type="text/css" href="/resources/news/news.css" />
  </property>

<property name="context">@context;noquote@</property>
<property name="title">@title@</property>

<if @item_exist_p@ eq "0">
   <h2>#news.lt_Could_not_find_the_re#</h2>
</if>
<else>
<div>
<div id="boxescontrel">
	<include src=news
		item_id=@item_id;noquote@
		publish_title=@title;noquote@
		publish_body=@publish_body;noquote@
		publish_image=@publish_image;noquote@
		publish_date=@publish_date;noquote@
		image_description=@image_details.description@
		image_size=@image_width_size@
		creator_link=@creator_link;noquote@
		file_list=@file_list;noquote@
		videos_list=@videos_list;noquote@
		sounds_list=@sounds_list;noquote@>

	
	<div id="share">
	     <p><span><strong>#news.Share#:</strong></span></p>
	     <ul>
		<li><a target="_blank" rel="external nofollow" href="http://www.facebook.com/sharer.php?u=@site_url@@package_url@item?item_id=@item_id_orig@&amp;t=@publish_title_one@"><img src="/resources/news/socialnetworks/facebook.jpg" alt="Facebook"></a></li>
		<li><a href="http://twitter.com/home?status=@publish_title_one@ @site_url@/o/@item_id_orig@" title="@publish_title_one@"><img src="/resources/news/socialnetworks/twitter.jpg" alt="Share on Twitter"></a></li>
		<li><a target="_blank" href="http://del.icio.us/post?url=@site_url@@package_url@item?item_id=@item_id_orig@&amp;title=@publish_title_one@" title="Delicious"><img src="/resources/news/socialnetworks/delicious.jpg" alt="Delicious"></a></li>
		<li id="orkut-share"><a href="http://promote.orkut.com/preview?nt=orkut.com&tt=@publish_title_one@&du=@site_url@@package_url@item?item_id=@item_id_orig@" rel="nofollow" target="_blank"><img src="/resources/news/socialnetworks/orkut.jpg" style="border: medium none;cursor: pointer;" alt="Share this on Orkut!" /></a></li>
	    </ul>
	</div>

</div>

		<div id="contrel">

		<strong class="destaque2">#news.Latest_news#</strong>
		<ul class="maisnot">
					<multiple name="news_items">
					<li><a href="item?item_id=@news_items.item_id@">@news_items.publish_title@</a></li>
					</multiple>
		</ul>
		<div class="linetop">
		<img width="21" height="16" alt="rss" src="/resources/news/rss.gif"/>
		<a href="rss">RSS</a> | <a href="http://pt.wikipedia.org/wiki/RSS">#news.learn_rss#</a>
		</div>
		<div class="linetop">
			<img width="21" height="17" src="/resources/news/imprimir.gif">
			<a class="thickbox" onclick="javascritpt:window.print(); return false;" href="#"> #news.print_this_news#</a>
		</div>
		<div class="linetop">
			<img height="17" width="21" alt="Enviar por e-mail" src="/resources/news/enviar_not.gif">
			<a id="sendemail" href="#" onclick="getElementById('sendemailform').style = 'inline'; return false;"> Envie por e-mail</a>

			<div id="loading" style="display: none;">
	
					<img src="/resources/news/loading.gif" alt="carregando" />
			</div>

			<div id="erro" style="display:none" class="noline">
				<img src="/resources/news/erro.jpg" alt="erro" class="imgfloat" />
				<p><strong class="verm">Erro</strong></p>
				<p class="verm" id="erro-texto"></p>
			</div>
		
			<div id="alerta" style="display:none" class="noline">
					<img src="/resources/news/alerta.jpg" alt="alerta" class="imgfloat" />
					<p><strong class="lar">Aten&ccedil;&atilde;o</strong></p>
					<p class="lar" id="alerta-texto"></p>
			</div>
	
			<div id="sucesso" style="display:none" class="noline">
				<img src="/resources/news/sucesso.jpg" alt="sucesso" class="imgfloat" />
				<p><strong>Sucesso</strong></p>
				<p id="sucesso-texto"></p>
			</div>	
			<div id="sendemailform" style="display: none;">
				<form name="email" action="send" method="post">
					<input type="hidden" name="item_id" value="@item_id_orig@" />
					<p>
						<label>Seu nome*:</label><br />
						<input type="text" name="name" class="iptEnviaEmail" />
					</p>
					<p>
						<label>E-mail do destinatário*:</label><br />

						<input type="text" name="email" class="iptEnviaEmail" />
					</p>
					<p>
						<label>Envie algum comentário:</label><br />
						<textarea name="texto" rows="2" cols="30" class="iptEnviaEmail"></textarea>
					</p>
					<p>

					<input type="button" name="Enviar" value="Enviar" class="botao" onclick="sendEmail(document.email);" />
					</p>
				</form>
			</div>
		</div>

	</div>
	

</div>


<if @comments@ ne "">
<h2>#news.Comments#</h2>
@comments;noquote@
</if>


<div class="notas_noticias">
<!-- <if@comment_link@ not nil>
  <li>@comment_link;noquote@</li>
</if> --> 

@replicate_link;noquote@

@edit_link;noquote@
 
@image_edit_link;noquote@

@attach_link;noquote@

@delete_link;noquote@

@status_link;noquote@


</div>

</else>

<if 0>
	<if @ratings.all_ratings@ gt 0>
     		 <p>#ratings.Ave_Rating# @ratings.stars;noquote@ @ratings.all_ratings@</p>
   	 </if>
    	<else>
    	  <p><b>#ratings.Unrated#</b></p>
 	   </else>
 	   <if @current_rating@ gt 0>
 	     <p>#ratings.Your_rating#: @stars;noquote@</p>
 	     <p>@rate_form;noquote@</p>
  	  </if>
 	   <else>
  	    <p>@rate_form;noquote@</p>
 	   </else>
</if>

