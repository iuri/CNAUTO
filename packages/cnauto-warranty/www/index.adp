<master>

<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<br>
<h1>@title;noquote@</h1>


<table cellpadding="3" cellspacing="3">
  <tr>
    <td>&nbsp;</td>
    <td align="right" valing="top">
      <form action="index" method="post" name="search">
        <input type="text" name="keyword" id="keyword" value="Chassis" size="30px"> &nbsp; <input type="submit" name="submit" id="submit" value="#cnauto-assurance.Search#">
      </form>

    </td>
  </tr>
  <tr>
    <td class="list-filter-pane" valign="top" style="width:200px">
        <listfilters name="claims"></listfilters>
    </td>
    <td class="list-list-pane" valign="top">
      <listtemplate name="claims"></listtemplate>
    </td>
  </tr>
</table>