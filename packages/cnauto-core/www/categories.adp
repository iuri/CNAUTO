<master>

<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>


<table cellpadding="3" cellspacing="3">
  <tr>
      <td class="list-filter-pane" valign="top" style="width:200px">
        <listfilters name="categories"></listfilters>
      </td>
      <td class="list-list-pane" valign="top">
        <span align="right">
	<form action="categories" method="post" name="search">
	  <input type="text" name="keyword" id="ketyword"xs>
	  <input type="submit" name="submit.x" id="submit.x" value="#cnauto-core.Search#">     
	</form>
	</span>
        <listtemplate name="categories"></listtemplate>
      </td>
  </tr>
</table>

