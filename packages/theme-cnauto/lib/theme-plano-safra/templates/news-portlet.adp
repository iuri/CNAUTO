<div id="noticia">
  <if @news_items:rowcount@ nil>
    <p>#news-portlet.No_News#</p>
  </if>
  <else>
    <h1>NOTÍCIAS </h1>

    <div class="box-noticia-posts">
      <multiple name="news_items">
        <h3><a href="@news_items.view_url@">@news_items.publish_title@</a></h3>
        <p>@news_items.publish_body150@</p>
      </multiple>   
    
      <h3><a href="@news_url@">#news.leia_todas#</a></h3>
    </div>
  </else>
  <if @admin_p@>
    <a href="@news_url@item-create" title="#news-portlet.Add_a_News_Item#">#news-portlet.Add_a_News_Item#</a>
  </if>
</div>

