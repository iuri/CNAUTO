<if @news:rowcount@ gt 0 or @show_empty_p@ true>
	<if @class@ eq "portalElement">
			<h3><a href="@base_url@">#news.News#</a></h3>
	</if>
	<else>
		<h2><a href="@base_url@">#news.Latest_News#</a></h2>
	</else>
	<if @news:rowcount@ eq 0>
	<p>#news.No_recent_news#</p>
	</if><else>
	<multiple name="news">
	<if @class@ eq "portalElement">
		<h4><a href="@news.url@">@news.title@</a></h4>
	</if>
	<else>
		<h3><a href="@news.url@">@news.title@</a></h3>
	</else>
	
	<p>@news.lead@<br />@news.date@</p>
	</multiple>
	<p><a href="@base_url@">#news.More_news#</a></p>
	</else>
</if>

