<%

    #
    #  Copyright (C) 2001, 2002 MIT
    #
    #  This file is part of dotLRN.
    #
    #  dotLRN is free software; you can redistribute it and/or modify it under the
    #  terms of the GNU General Public License as published by the Free Software
    #  Foundation; either version 2 of the License, or (at your option) any later
    #  version.
    #
    #  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
    #  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
    #  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
    #  details.
    #

%>

<if @news_items:rowcount@ nil>
	<p>#news-portlet.No_News#</p>
</if>
<else>
	
	<div id="caixa-noticia"> 
	<multiple name="news_items">
		<if @news_items.rownum@ eq 1>
			  <div class="caixa-noticia-principal"> 
			    <div class="caixa-noticia-foto">
						<a href="@news_url@item?item_id=@news_items.item_id@" title="@news_items.publish_title@"><img src="@news_url@image/@news_items.image_id@" alt="@news_items.publish_title@" /></a>
			    </div> 
	
			    <div class="caixa-noticia-link"> 
					  <p class="caixa-fonte"><a href="@news_url@item?item_id=@news_items.item_id@" title="@news_items.publish_title@">@news_items.publish_title@</a></p>
					  <p class="caixa-fonte-dois"><a href="@news_url@item?item_id=@news_items.item_id@" title="@news_items.publish_title@">@news_items.publish_body;noquote@</a></p>
	      			<div class="caixa-midias">
						<!-- <ul>
							<li><a title="Twitter" href="javascript:window.location='@news_items.twitter_url@';" target="_blank" id="twitter" rel="nofollow"><img class="sociable-hovers" alt="Twitter" title="Twitter" src=""/></a></li>
							<li><a title="Facebook" href="" target="_blank" id="facebook" rel="nofollow"><img class="sociable-hovers" alt="Facebook" title="Facebook" src=""/></a></li>
							<li><a title="del.icio.us" href="" target="_blank" id="del.icio.us" rel="nofollow"><img class="sociable-hovers" alt="del.icio.us" title="del.icio.us" src=""/></a></li>
						</ul> -->
			        </div> 
				</div>
	    	  </div> 
	   </if>
	   <else>
			<if @news_items.rownum@ eq 2>
		  		<div id="caixa-noticia-dois"> 
			</if>

    		<div class="caixa-noticia-dois">
				<a href="@news_items.url@item?item_id=@news_items.item_id@" title="@news_items.publish_title@">@news_items.publish_title@</a>
			</div>
	  </else>
	</multiple>

		<div class="caixa-noticia-leiamais"><a href="@news_url@">#news.leia_todas#</a></div>
	<if @news_items:rowcount@ gt 1></div></if>
   </div>



</else>

<if @admin_p@>
	<ul>
		<li class="bt_administrator">
			<a href="@news_url@item-create" title="#news-portlet.Add_a_News_Item#">#news-portlet.Add_a_News_Item#</a>
		</li>
	</ul>
</if>



