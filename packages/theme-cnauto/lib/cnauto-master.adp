<!-- 
# --------------------------------------------------------------------
# /packages/theme-cnauto/lib/cnauto-master.adp
# @author Iuri Sampaio (iuri.sampaio@iurix.com)
# @creation-date 2011-10-08
# ----------------------------------------------------------------------
-->
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
      <a href="@system_url@/ivc">www.ivcmotors.com.br</a> 
    </div>  
  </div>
  <div class="clear"></div>

 
     <div class="column1">
     	  <a href="test">TEst1</a>
     </div>
     <div class="column2">
     	  <a href="test">TEst2</a>
     </div>


  <slave>
</div>



