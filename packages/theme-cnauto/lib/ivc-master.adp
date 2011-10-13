<master src="/www/blank-compat">
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>


<div class="main">
    <div class="logo">
      <img src="/resources/theme-cnauto/images/logo-ivc.jpg" width="120px">
    </div>
    <div class="newsletter_form">
      <form action="newsletter_add" method="post">
        Receba nosso Informativos: 
        Nome: <input class="input_text" type="text" name="name">
        Email: <input class="input_text" type="text" name="email">
        <input class="input_submit" type="submit" name="submit" value="OK">
      </form>
    </div>
   
  <div class="title">
      <div class="locale">
        <a href="@pt_locale_url@"><img border="0" src="@pt_locale_img@"></a>  
        <a href="@en_locale_url@"><img border="0" src="@en_locale_img@"></a>  
      </div>
   
    <div class="url">
      <a href="#">www.ivcmotors.com.br</a> 
    </div>  
  </div>
  <div class="clear"></div>
  <div class="menu">  
   
    <img style="float:left" border="0px" src="/resources/theme-cnauto/images/menu-left.png">
    <div class="menu_content"> 
      <a href="/ivc/content/company">#theme-cnauto.Company#</a>|
      <a href="/ivc/content/products">#theme-cnauto.Products#</a>|
      <a href="/ivc/content/services">#theme-cnauto.Services#</a>|
      <a href="/ivc/content/contact">#theme-cnauto.Contact#</a>
      <div class="search">
        <form action="search" method="post"> 
     	  <input class="input_text" type="text" name="search">
          <input class="input_submit" type="submit" name="submit" value="OK">
        </form>
      </div>
    </div>
    <div class="menu-image-right">
      <img style="margin:0px; float:right" border="0px" src="/resources/theme-cnauto/images/menu-right.png"></div>
  </div>

  <div class="clear"></div>


  <div class="content">
<!--    <img style="float:left" border="0px" src="/resources/theme-cnauto/images/foto1.png"> -->
   <slave>

  </div>

  <div class="clear"></div>

  <div class="footer">
    <img style="float:left" border="0px" src="/resources/theme-cnauto/images/footer-left.png">

    <div class="footer-content">
      <div class="footer-left">
        #theme-cnauto.Address#
      </div>
      <div class="footer-navigation">
        <ul>
          <li><a href="">#theme-cnauto.Home#</a> |</li> 
          <li><a href="">#theme-cnauto.SiteMap#</a> |</li> 
      	  <li><a href="">#theme-cnauto.Terms_of_Use#</a> |</li>
          <if @login_url@ not nil> 
            <li><a href="@login_url@">Log in </a> |</li> 
          </if>
          <if @logout_url@ not nil>
            <li><a href="@pvt_home_url@">@pvt_home_name;noquote@</a> | </li>
       	    <if @admin_url@>
              <li><a href="@admin_url@">#theme-cnauto.Admin#</a> |</li>
            </if>
	    <li><a href="@logout_url@">Log out</a> | </li>
          </if>
      	</ul>   
        <br/> Siga-nos no Twitter 
      </div>
    </div>
    <div class="footer-image-right"><img style="margin:0px;" src="/resources/theme-cnauto/images/footer-right.png"></div>

  </div>



</div>



