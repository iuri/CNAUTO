<div class="news_full">

	<div class="font_size_box">
		<div class="font_size">
			<p>#acs-templating.Font_size#</p>
			<ul>
				<li class="fontdown"><a href="#" onclick="fontChange('-', 'news_main');return false" title="#acs-templating.Font_Size_Down#">#acs-templating.Font_Size_Down#</a></li>
				<li class="fontup"><a href="#" onclick="fontChange('+', 'news_main');return false" title="#acs-templating.Font_Size_up#">#acs-templating.Font_Size_Up#</a></li>
			</ul>
		</div>
	</div>

	<comment>#news.lt_This_is_the_default_t#</comment>
	<!-- <p class="publicador">#news.Contributed_by# <strong>@creator_link;noquote@</strong></p> -->


	<div class="img_destaque_noticia_completa_box">
	
	<if @videos_list@ not nil> 
			<div class="img_destaque_noticia_completa">
    			@videos_list;noquote@
			</div> 
	</if>
	<else>
		<if @publish_image@ not nil>
			<div class="img_destaque_noticia_completa">
			<a rel="lightbox"  href="@publish_image@" title="@publish_title@"><img src="@publish_image@" class="newsImage" alt="@publish_title@"/></a>
			</div>
			<if @image_description@ not nil>
				<h4>@image_description@ @videos_list@</h4>
			</if>
	
		</if> 
		</else>


		<if @file_list@ not nil> 
			<strong>#news.Attached_files#</strong>
			<div class="sutien">
				<ul class="maisnot">@file_list;noquote@</ul>
			</div>
		</if>
	
	</div>

	<strong class="destaqueprincipal">@publish_title@</strong>
	<p class="publish_date">@publish_date;noquote@</p>


	<if @publish_lead@ not nil><p class="newsLead">@publish_lead@</p></if>
		<div class="fontsize_1" id="news_main"><p>@publish_body;noquote@</p></div>

</div>
