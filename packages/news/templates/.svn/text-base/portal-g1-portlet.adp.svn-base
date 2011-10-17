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

<div class="news">
<if @news_items:rowcount@ nil>
	    <div>
		<p>#news-portlet.No_News#</p>
	
</if>
<else>
 	    <div  id="destaque">
		<h6>
			<a href="@news_url@item?item_id=@max_priority_item_id@" title="@max_priority_publish_title@">@max_priority_publish_title@</a>
		</h6>
			<div><a href="@news_url@item?item_id=@max_priority_item_id@" title="@max_priority_publish_title@"><img src="@news_url@image/@max_priority_image_id@" alt="@max_priority_publish_title@" /></a></p></div>
			<p><a href="@news_url@item?item_id=@max_priority_item_id@" title="@max_priority_publish_title@">@max_priority_publish_body;noquote@</a></p>
	    </div>

	    <div id="mais-noticias">
				<multiple name="news_items">
	    				<div class="mais-noticias-um">
		        			<h1><a href="@news_items.url@item?item_id=@news_items.item_id@" title="@news_items.publish_title@">@news_items.publish_date_ansi@ - @news_items.publish_title@</a></h1>
					</div>
	    			</multiple>
</else>

		<ul>
			<if @admin_p@><li class="bt_administrator"><a href="@news_url@item-create" title="#news-portlet.Add_a_News_Item#">#news-portlet.Add_a_News_Item#</a></li></if>
			<li class="bt_administrator"><a href="@news_url@" title="Leia todas">#news.leia_todas#</a></li>

		</ul>

	    </div>
</div>

