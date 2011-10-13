<master src="/www/blank-compat">
  <property name="title">@title@</property>
  <property name="header_stuff"> @header_stuff;noquote@ </property>
  <if @context@ not nil><property name="context">@context;noquote@</property></if>
  <if @focus@ not nil><property name="focus">@focus;noquote@</property></if>
  <if @doc_type@ not nil><property name="doc_type">@doc_type;noquote@</property></if>
   



<!-- Abre main -->
<div id="main">

  <!-- Barra Governo Federal  -->
  <div id="barra-brasil-v2-exp" class="gif">
    <div class="divEsq"><img src="/resources/theme-plano-safra/images/gif/barra-gov-bv2-esq.gif" alt="" /></div>
    <div class="divCentro">
      <a href="http://www.mda.gov.br" id="logo-republica-bv2" target="_blank" title="Ministério do Desenvolvimento Agrário">
      <img src="/resources/theme-plano-safra/images/gif/logo-presidencia-bv2.gif" alt="Rep&uacute;blica Federativa do Brasil" /></a>
      <a href="http://www.brasil.gov.br" id="logo-gov-bv2" target="_blank" title="Brasil - Pa&iacute;s rico &eacute; pa&iacute;s sem pobreza">
      <img src="/resources/theme-plano-safra/images/gif/logo-gov-bv2.gif" alt="Brasil - Pa&iacute;s rico &eacute; pa&iacute;s sem pobreza" /></a>
    </div>
  </div>
  <!-- Fecha Barra Governo Federal  -->


  <!-- Abre header -->
  <div id="header"> 

    <div id="midia-social">
      <a href="http://www.facebook.com/#!/profile.php?id=100000889800731&sk=info" title="facebook-ministerio do desenvolvimento agrário"><img src="/resources/theme-plano-safra/images/icone-facebook.gif" alt="facebook-ministerio do desenvolvimento agrário" border="0" /> </a>
      <a href="http://www.twitter.com/mdagovbr" title="twitter-ministerio do desenvolvimento agrário"><img src="/resources/theme-plano-safra/images/icone-twitter.gif" alt="twitter-ministerio do desenvolvimento agrário" border="0" /> </a>
      <a href="http://www.youtube.com/comunicacaosocialmda" title="youtube-ministerio do desenvolvimento agrário"><img src="/resources/theme-plano-safra/images/icone-youtube.gif" alt="youtube-ministerio do desenvolvimento agrário" border="0" /></a>
    </div>
    <a href="@subsite_url@" title="PLANO SAFRA DA AGRICULTURA FAMILIAR 2011/2012"> <h4>PLANO SAFRA DA AGRICULTURA FAMILIAR 2011/2012</h4>  </a>
  </div>
  <!-- Fecha header -->

  
  <!--Abre menu -->
  <div id="menu_navegacao">
      <ul>
        <li><a href="@subsite_url@" title="Pagina Inicial">PÁGINA INICIAL </a></li>
        <li> | </li>
        <li><a href="@subsite_url@news" title="Notícias">NOTÍCIAS </a></li>
        <li> | </li>
        <li><a href="@subsite_url@radiosafra" title="Rádio Mda">RÁDIO MDA </a></li>
        <li> | </li>
        <li><a href="@subsite_url@tvsafra" title="Tv Mda">TV MDA </a></li>
        <li> | </li>
        <li><a href="@subsite_url@publicacoes" title="Publicações">PUBLICAÇÕES </a></li>
        <li> | </li>
        <li><a href="@subsite_url@xowiki/imprensa" title="Sala de Impresa">SALA DE IMPRENSA</a></li>
      </ul>
    </div>
    <!-- Fecha menu -->


  
 <!-- Abre content  -->
  <slave>
 <!-- Fecha content -->

  <!-- Abre footer  -->

  <div id="footer">
    <ul>
      <li class="one"><a href="/resources/theme-plano-safra/images/balao-azul.gif" class="preview" ><img src="/resources/theme-plano-safra/images/01.jpg" /> </a></li>
      <li class="two"><a href="/resources/theme-plano-safra/images/balao-amarelo.gif" class="preview" ><img src="/resources/theme-plano-safra/images/02.jpg" /></a></li>
      <li class="three"><a href="/resources/theme-plano-safra/images/balao-vermelho.gif" class="preview" ><img src="/resources/theme-plano-safra/images/03.jpg" /></a></li>
    </ul>
<div class="footer-text"><br>Ministério do Desenvolvimento Agrário - Esplanada dos Ministérios, Bloco A/Ala Norte - CEP 70050-902 - Brasília-DF </div>


	<p> <span style="float: left; margin-top: 7px;"><img alt="Login Portal" src="/resources/theme-mda/imagens/mdamain/login.gif" style="margin-right: 5px;"/></span>
		<span style="margin-top: 10px; float: left;">
		
		<if @untrusted_user_id@ eq 0>
				<a href="@subsite_url@/register/?return_url=@return_url@" title="Login no portal" tabindex="4">Àrea Restrita</a>
		</if>
		<else>
				<a href="@subsite_url@register/logout" title="Sair do Portal" tabindex="4">Sair</a>
		</else>
		</span>
	</p>




<if @subsite_admin_p@>

    <h3>#acs-subsite.Administrator#</h3>
    <ul>
        <multiple name="applications">
          <li><a href="@subsite_url@@applications.name@" title="@applications.instance_name@">@applications.instance_name@</a>
          <if @applications.available@ not nil>
            <a href="@subsite_url@admin/portal/application-portlet-add?package_id=@applications.package_id@&application_key=@applications.package_key@&return_url=@return_url@">Add portlet Application</a>
          </if>
          </li><br>
        </multiple>
        <li><a href="@subsite_url@admin/menus/" title="#theme-mda.Menus#">#theme-mda.Menus#</a></li>
        <if @sw_admin_p@>
           <li><a href="@new_portal_url@admin/portal-config?portal_id=@portal_id@&referer=@return_url@">Portal Edit</a></li>
        </if>
    </ul>
</if>

  </div>
<!-- Fecha fotter -->

<script type="text/javascript">

    var _gaq = _gaq || [];
    _gaq.push(['_setAccount', 'UA-24369939-1']);
    _gaq.push(['_trackPageview']);
    
    (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
    })();
    
    </script>
</div>
<!-- Fecha main -->



