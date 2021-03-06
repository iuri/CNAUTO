<master src="/www/blank-compat">
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>




<div class="main">
  <div class="logo">
    <a href="@system_url@/ivc"><img src="/resources/theme-ivc/images/logo-ivc.jpg" width="120px"></a>
  </div>
  <div class="newsletter_form">
      <form action="/packages/newsletter/lib/newsletter-email-new" method="post">
        #ivc-core.Receive_our_newsletter#: 
        #ivc-core.Name#: <input class="input_text" type="text" name="name">
        #ivc-core.Email#: <input class="input_text" type="text" name="email">
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
   
    <img style="float:left" border="0px" src="/resources/theme-ivc/images/menu-left.png">
    <div class="menu_content"> 
      <a href="/ivc/content/company">#ivc-core.Company#</a>|
      <a href="/ivc/content/products">#ivc-core.Products#</a>|
      <a href="/ivc/content/services">#ivc-core.Services#</a>|
      <a href="/ivc/content/contact">#ivc-core.Contact#</a>
      <div class="search">
        <form action="search" method="post"> 
     	  <input class="input_text" type="text" name="search">
          <input class="input_submit" type="submit" name="submit" value="OK">
        </form>
      </div>
    </div>
    <div class="menu-image-right">
      <img style="margin:0px; float:right" border="0px" src="/resources/theme-ivc/images/menu-right.png"></div>
  </div>

  <div class="clear"></div>


  <div class="content">
       <div class="content-left">&nbsp;</div>
       <div class="content-right">
         <h1>#ivc-core.Under_Construction#</h1>
        <img src="/resources/theme-ivc/images/under-construction.jpg" width="300px"></div>
   </div>

  <div class="clear"></div>

  <div class="footer">
    <img style="float:left" border="0px" src="/resources/theme-ivc/images/footer-left.png">

    <div class="footer-content">
      <div class="footer-left">
        #ivc-core.Address#
      </div>
      <div class="footer-navigation">
        <ul>
          <li><a href="/ivc">#ivc-core.Home#</a> |</li> 
          <li><a href="/ivc/site-map">#ivc-core.SiteMap#</a> |</li> 
      	  <li><a href="/ivc/content/terms">#ivc-core.Terms_of_Use#</a> |</li>
          <if @login_url@ not nil> 
            <li><a href="@login_url@">Log in </a> |</li> 
          </if>
          <if @logout_url@ not nil>
            <li><a href="@pvt_home_url@">@pvt_home_name;noquote@</a> | </li>
       	    <if @admin_url@>
              <li><a href="@admin_url@">#ivc-core.Admin#</a> |</li>
            </if>
	    <li><a href="@logout_url@">Log out</a> | </li>
          </if>
      	</ul>   
        <br/><!-- <a href=""><img border="10" width="40" src="/resources/theme-ivc/images/twitter_icon.png"></a>  -->
      </div>
    </div>

    <div class="footer-image-right"><img style="margin:0px;" src="/resources/theme-ivc/images/footer-right.png"></div>

  </div>



</div>



