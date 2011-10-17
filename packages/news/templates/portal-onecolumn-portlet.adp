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
	<div class="news_onecolumn">
	<multiple name="news_items">
		<if @news_items.rownum@ eq 1>
			  <p><strong>@news_items.publish_date_ansi@</strong> <a href="@news_url@item?item_id=@news_items.item_id@">@news_items.publish_title@</a></p>
	   		  <p><img src="@news_url@image/@news_items.image_id@" alt="@news_items.publish_title@"/></p>
		   </if>
		   <else>
 			<p><strong>@news_items.publish_date_ansi@</strong> <a href="@news_url@item?item_id=@news_items.item_id@">@news_items.publish_title@</a></p>
		   </else>
	</multiple>
	<div><a href="@news_url@">#news.leia_todas#</a></div>
	</div>

</else>

<if @admin_p@>
	<ul>
		<li class="bt_administrator">
			<a href="@news_url@item-create" title="#news-portlet.Add_a_News_Item#">#news-portlet.Add_a_News_Item#</a>
		</li>

	</ul>
</if>


