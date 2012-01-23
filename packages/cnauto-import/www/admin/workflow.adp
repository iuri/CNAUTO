<master>

<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<br>
<h1>@title;noquote@</h1>
<listtemplate name="workflow_steps"></listtemplate>

<form action="workflow-ae" method="post">
  <table><tr> 
  <td valign="top" align="left" width="30%"><input type="text" name="name"></td>
  <td valign="top" align="left" width="50%"><input type="text" name="pretty_name">
  <input type="submit" name="submit" value="#cnauto-import.Save#"></td>
  </tr></table>
</form>