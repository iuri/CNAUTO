<master>
  <property name="context">@context;noquote@</property>
  <property name="title">#news.News#</property>
  <property name="page-title">@title;noquote@</property>
  <property name="header_stuff">
	<link rel="stylesheet" type="text/css" href="/resources/news/news.css" />
	<link rel="alternate" type="application/rss+xml" title="@rss_title@" href="@news_url@rss/"/>

  </property>


	  <if @news_items:rowcount@ eq 0>
	    <p><i>#news.lt_There_are_no_news_ite#</i></p>
	  </if>
	  <else>
	    <if @allow_search_p@ eq "1" and @search_url@ ne "">
	      <div>#news.Search#
	        <form action="@search_url@search">
    	      <input type="text"  name="q" value="" />
	          <input type="submit" name="search" value="Search" />
	        </form>
	      </div>
    	</if>

	</else>

	 <if @notification_chunk@ not nil and @user_id@ not eq 0>
	<p>@notification_chunk;noquote@</p>
	</if>



	<multiple name="news_items">

		<if @news_items.rownum@ eq 1 and @start@ eq 1 and @boxes_p@ and @category_id@ eq "">
    	<div class="noticias_destaques">
			<div class="noticia_destaque">
					<h2><a href="item?item_id=@news_items.item_id@">@news_items.publish_title@</a></h2>
					<p><a href="item?item_id=@news_items.item_id@">
						<div class="img_destaque01">
								<if @news_items.image_id@ not eq "">
									<img src="./image/@news_items.image_id@" alt="" />
								</if>
						</div></a></p>
					<p><a href="item?item_id=@news_items.item_id@">@news_items.publish_body;noquote@</a></p>
			</div>
		</if>



		<if @start@ eq 1 and @category_id@ eq "" and @boxes_p@>
			<if @news_items.rownum@ in 2 3 4>
				<div class="noticia_destaque02">
			</if>
			<if @news_items.rownum@ eq 5>
				<h1 class="titulo_padrao">#news.Other_news_1#</h1>
			</if>
			<if @news_items.rownum@ in 2 3 4>
				<h2><a href="item?item_id=@news_items.item_id@">@news_items.publish_title@</a></h2>
					<if @news_items.image_id@ not eq "">
						<div class="img_noticia_destaque02"><a href="item?item_id=@news_items.item_id@" title="">
						<div class="img_destaque02"><img width="150" src="./image/@news_items.image_id@" alt="" /></div></a></div>
					</if>
				<p><a href="item?item_id=@news_items.item_id@">@news_items.publish_body_small;noquote@</a></p>
				</div>
			</if>
			<if @news_items.rownum@ gt 4>
				<div class="listagem_noticia">
					<div class="topo_listagem_noticia">
						<div class="data_noticia"><p>@news_items.publish_date@</p></div>
						<div class="titulo_noticias_listagem"><h2><a href="item?item_id=@news_items.item_id@">@news_items.publish_title@</a></h2>
						<p>@news_items.publish_body_small;noquote@</p>
						</div>
					</div>
				</div>
			</if>

			<if @news_items.rownum@ eq 4>
				</div>
			</if>
		</if>
		<else>
				<div class="listagem_noticia">
					<div class="topo_listagem_noticia">
						<div class="data_noticia"><p>@news_items.publish_date@</p></div>
						<div class="titulo_noticias_listagem"><h2><a href="item?item_id=@news_items.item_id@">@news_items.publish_title@</a></h2>
						<p>@news_items.publish_body_small;noquote@</p></div>
					</div>
				</div>
		</else>
	

	</multiple>
 
    <p align="right" class="paginacao_noticias">@pagination_link;noquote@</p>
 
	<!--  <if @news_admin_p@ ne 0> 
    <ul>
      <li><a href="item-create">#news.Create_a_news_item#</a></li>
	   <if @rss_exists@ true>
      <li><a href="@rss_url@">#rss-support.Syndication_Feed# <img
            src="/resources/xml.gif" border="0" alt="Subscribe via RSS" valign="middle" /></a></li></if>
    </ul>  
  </if> --> 
    <if @news_create_p@ ne 0> 
      <ul>
        <li><a href="item-create">#news.Submit_a_news_item#</a></li>
      </ul>
    </if>

   
  <if @view_switch_link@ ne "">
    <ul>
      <li>@view_switch_link;noquote@</li>
    </ul>
  </if>
  
  <if @news_admin_p@ ne 0>
	    <div>[<a href="admin/">#news.Administer#</a>]</div>
  </if>




