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

	<if @max_priority_html@ not nil>
		<div id="cu3er-container" style="width:570px; outline:0;" >
		    <a href="http://www.adobe.com/go/getflashplayer">
		        <img src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif" alt="Get Adobe Flash player" />
		    </a>
		</div>
	</if>

	<if @max_priority_item_id@ not nil>
		<div class="portlet_main_news">
			<div class="max_priority">
				<h5> 
					<a href="@news_url@item?item_id=@max_priority_item_id@" title="@max_priority_publish_title@">@max_priority_publish_title@</a>
				</h5>
				<p><a href="@news_url@item?item_id=@max_priority_item_id@" title="@max_priority_publish_title@"><span class="cut_image"><img src="@news_url@image/@max_priority_image_id@" width="270" alt="" /></a></span></p>
				<p><a href="@news_url@item?item_id=@max_priority_item_id@" title="@max_priority_publish_title@">@max_priority_publish_body;noquote@</a></p>
			</div>
			<div class="others_news">
				<multiple name="news_items">
				<div class="news">
					<h6>
						<a href="@news_items.url@item?item_id=@news_items.item_id@" title="@news_items.publish_title@">@news_items.publish_title@</a>
					</h6>
					<p><a href="@news_items.url@item?item_id=@news_items.item_id@" title="@news_items.publish_title@">@news_items.publish_body;noquote@</a></p>
				</div>
				</multiple>
			</div>
		</div>
		<p class="more"><a href="@news_url@" title="#news-portlet.View_all_items#">#news-portlet.View_all_items#</a></p>
	</if>

	<if @javascript_gallery_p@>
		<script language=javascript>
		  var ContrRelogio = setTimeout ("run()", 7000);
		  moveNews();
		</script>
	</if>
</else>
	
<if @admin_p@>
	<ul>
		<li class="bt_administrator">
			<a href="@news_url@item-create" title="#news-portlet.Add_a_News_Item#">#news-portlet.Add_a_News_Item#</a>
		</li>
	</ul>
</if>


