<!--
    Display confirmation for deleting newsletter users.

    @author Iuri Sampaio (iuri.sampaio@iurix.com)
    @creation-date 2011-07-04
-->
<master>
<property name="context">@context_bar;noquote@</property>
<property name="title">#newsletter.Confirm_users_delete#</property>

<form method="post" action="newsletter-users-del-2">	
  <input type=hidden name="newsletter_id" value="@newsletter_id@">
  <input type=hidden name="return_url" value="@return_url@">
  <input type=hidden name=email value=@email@>
  <p>#newsletter.Are_you_sure_you_want_to_delete# ?<br \> </p>
  <multiple name="emails">@emails.elem;noquote@ <br /></multiple>
  <div><input type=submit value=#acs-kernel.common_Yes#><input type=submit value=#acs-kernel.common_No#></div>
</form>
