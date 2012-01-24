<master>

<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<br>
<h1>#cnauto-import.Add_workflow#</h1>
<form name="workflow-ae" action="workflow-ae" method="post">
  <table><tr> 
  <td valign="top" align="left" width="30%"><input type="text" name="name"></td>
  <td valign="top" align="left" width="50%"><input type="text" name="pretty_name">
  <input type="hidden" name="return_url" value="@return_url@">
  <input type="hidden" name="workflow_id" value="@workflow_steps.workflow_id@">
  <input style="float:right" type="submit" name="submit" value="#cnauto-import.Add_step#"></td>
  </tr></table>
</form>

<h1>@title;noquote@</h1>

<form name="workflow-update-sort" action="workflow-update-sort" method="post">
  <listtemplate name="workflow_steps"></listtemplate>
  <input type="hidden" name="return_url" value="@return_url@">
  <input style="float:right" type="submit" name="submit" value="#cnauto-import.Update_order#">
</form>

