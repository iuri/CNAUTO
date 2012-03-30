<master>

<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>


<table cellpadding="3" cellspacing="3" width="100%">
  <tr>
    <td class="list-filter-pane" valign="top" style="width:200px">
        <listfilters name="categories"></listfilters>
    </td>
    <td class="list-list-pane" valign="top">
      <table cellpadding="0" cellspacing="0" width="100%">
        <tr>
     	  <td valign="top"><h1>#cnauto-core.Categories#</h1></td>
          <td valign="top" class="list-list-pane" valign="top">
	    <form action="categories" method="post" name="search">
	      <input type="text" name="keyword" id="keyword">
	      <input type="submit" name="submit.x" id="submit.x" value="#cnauto-core.Search#">     </form>
          </td>
        </tr>
      </table>

      <listtemplate name="categories"></listtemplate>
    </td>
  </tr>
</table>

