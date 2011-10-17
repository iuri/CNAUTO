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


<div id="news_g1_text">
	<multiple name="news_items">
		<if @news_items.rownum@ eq 1>
			<div id="news_g1_text_items_main_item">
				<h2 class="title"><a title="@news_items.publish_title@" href="@news_url@item?item_id=@news_items.item_id@">@news_items.publish_title@</a></h2>
				<if @news_items.image_id@ not nil>
				<div class="cat-img-top-priority">
					<a href="@news_url@item?item_id=@news_items.item_id@" title="@news_items.publish_title@"><img alt="@news_items.publish_title@" src="@news_url@image/@news_items.image_id@" class="border-img"></a>
				</div>
				</if>
				<p><a href="@news_url@item?item_id=@news_items.item_id@" title="@news_items.publish_title@">@news_items.publish_body;noquote@</a></p>
			</div>
		</if>
		<else>
			<div class="news_g1_text_items_item">
				<if @news_items.image_id_size_3@ not nil>
				<div class="cat-img">
					<a href="@news_url@item?item_id=@news_items.item_id@" title="@news_items.publish_title@"><img alt="@news_items.publish_title@" src="@news_url@image/@news_items.image_id_size_3@" class="border-img"></a>
				</div>
				</if>
				<h2><a title="@news_items.publish_title@" href="@news_url@item?item_id=@news_items.item_id@">@news_items.publish_title@</a></h2>
				<p>@news_items.publish_body;noquote@</p>
			</div>
		</else>
	</multiple>
	
</div>

</else>

<ul>

<if @admin_p@>
		<li class="bt_administrator">
			<a href="@news_url@item-create" title="#news-portlet.Add_a_News_Item#">#news-portlet.Add_a_News_Item#</a>
		</li>
</if>
<li><a href="@news_url@" title="#news-portlet.All_news#">#news-portlet.All_news#</a></li>



</ul>

