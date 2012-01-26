<master>

<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<br>
<h1>#cnauto-import.Add_incoterm#</h1>

<form action="incoterm-ae" method="post">
  <table><tr> 
  <td valign="top" align="left" width="30%">
    #cnauto-import.Code#: <input type="text" name="name">
  </td>
  <td valign="top" align="left" width="50%">
    #cnauto-import.Name#: <input type="text" name="pretty_name">
    <input type="hidden" name="return_url" value="@return_url@">
    <input type="submit" name="submit" value="#cnauto-import.Add#">
  </td>
  </tr></table>
</form>

<h1>@title;noquote@</h1>
<listtemplate name="incoterms"></listtemplate>
