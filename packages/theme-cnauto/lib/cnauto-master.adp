<master src="/www/blank-master">

<div class="main">
  <div class="header">
    <div class="logo">&nbsp;</div>
    <div class="header-navigation">
      <ul>
          <if @login_url@ not nil> 
            <li><a href="@login_url@">#cnauto-core.Log_in# </a> </li> 
          </if>
          <if @logout_url@ not nil>
            <li><a href="@pvt_home_url@">@pvt_home_name;noquote@</a> | </li>
       	    <if @admin_url@>
              <li><a href="@admin_url@">#cnauto-core.Admin#</a> |</li>
            </if>
	    <li><a href="@logout_url@">#cnauto-core.Log_out#</a></li>
          </if>
      </ul>
    </div>
    <div class="breadcumbs"> 
      <br>
      <if @context_bar@ not nil>
        @context_bar;noquote@
      </if>
      <else>
        <if @context:rowcount@ not nil>
        <ul class="compact">
          <multiple name="context">
          <if @context.url@ not nil>
            <li><a href="@context.url@">@context.label@</a> @separator@</li>
          </if>
          <else>
            <li>@context.label@</li>
          </else>
          </multiple>
        </ul>
        </if>
      </else>

    </div>   

    <if @navigation:rowcount@ not nil>
      <list name="navigation_groups">
        <div id="@navigation_groups:item@-navigation">
            <ul>
              <multiple name="navigation">
                <if @navigation.group@ eq @navigation_groups:item@>
                  <li<if @navigation.id@ not nil> id="@navigation.id@"</if>><a href="@navigation.href@"<if @navigation.target@ not nil> target="@navigation.target;noquote@"</if><if @navigation.class@ not nil> class="@navigation.class;noquote@"</if><if @navigation.title@ not nil> title="@navigation.title;noquote@"</if><if @navigation.lang@ not nil> lang="@navigation.lang;noquote@"</if><if @navigation.accesskey@ not nil> accesskey="@navigation.accesskey;noquote@"</if><if @navigation.tabindex@ not nil> tabindex="@navigation.tabindex;noquote@"</if>>@navigation.label@</a></li>
          </if>
          </multiple>
        </ul>
      </div>
    </list>
  </if>
       
  </div>
  <div class="content">
    <slave>
  </div>
 
  <div class="footer">
    <div class="footer-navigation">
      <ul>
          <li><a href="/cnauto/site-map">#cnauto-core.SiteMap#</a> |</li> 
      	  <li><a href="http://www.cnauto.com.br/materias.php?cd_secao=12">#cnauto-core.Terms_of_Use#</a> |</li>
          <li><a href="http://www.cnauto.com.br/materias.php?cd_secao=39">#cnauto-core.Contact_us#</a></li> 
      </ul>
    </div>
  </div>
 



</div>