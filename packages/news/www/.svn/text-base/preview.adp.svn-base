<master>
<property name="header_stuff">
	<link rel="stylesheet" type="text/css" href="/resources/news/news.css" />
  </property>

<property name="context">@context;noquote@</property>
<property name="title">@title@</property>
<h1 style="color:red; font-weight:bold; font-size:40px;">&nbsp;&nbsp;&nbsp;&nbsp;#news.Preview_news_item#</h1> 
<br>
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
  </div>
  <div id="contrel"></div>
</div>
<div class="notas_noticias">
    <a href="@edit_item_url@">#news.Edit_item#</a>
    <a href="@publish_item_url@">#news.Publish_item#</a>
    <a href="@delete_item_url@">#news.Delete_item#</a>
</div>
</else>

