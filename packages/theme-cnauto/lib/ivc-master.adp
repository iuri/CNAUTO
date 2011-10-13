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
  <div class="title"><a href="#">www.ivcmotors.com.br</a></div>
  <div class="clear"></div>
  <div class="menu">  
   
    <img style="float:left" border="0px" src="/resources/theme-cnauto/images/menu-left.png">
    <div class="menu_content"> 
      <a href="empresa">Nossa Empresa</a>|
      <a href="produtos">Produtos</a>|
      <a href="servico">Servicos</a>|
      <a href="contato">Contato</a>
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
    <img style="float:left" border="0px" src="/resources/theme-cnauto/images/foto1.png">
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
          <li><a href="">Home</a> |</li> 
          <li><a href="">Mapa do Site</a> |</li> 
      	  <li><a href="">Termos de Uso</a> |</li>
          <if @login_url@ not nil> 
            <li><a href="@login_url@">Log in </a> |</li> 
          </if>
          <if @logout_url@ not nil>
            <li><a href="@pvt_home_url@">@pvt_home_name;noquote@</a> | </li>
       	    <if @admin_url@>
              <li><a href="@admin_url@">@admin_name;noquote@</a> |</li>
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



