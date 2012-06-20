<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<table width="100%" cellpadding="0" cellspacing="0">
  <tr>
    <td align="top" valign="left">
      <ul>
        <li style="list-style:none; display:inline;"><a href="persons/">#cnauto-resources.Persons#</a> </li>
        <li style="list-style:none; display:inline;">  <a href="vehicles/">#cnauto-resources.Vehicles#</a> </li>
        <li style="list-style:none; display:inline;">  <a href="parts/">#cnauto-resources.Parts#</a> </li>
        <li  style="list-style:none; display:inline;">  <a href="resource-ae">#cnauto-resources.Add_resource#</a> </li>
        <if @admin_p@>
          <li  style="list-style:none; display:inline;"><a href="@admin_url@">#cnauto-resources.Admin#</a> </li>
        </if>
      </ul>
    </td>
    <td valign="top" align="right">
      <br \>
      <form name="search" method="post">
        <input type="text" name="keyword" id="keyword" value="">
	<input type="submit" name="submit" id="submit" value="#cnauto-core.Search#">
      </form>
    </td>
  </tr>
</table>

<h1>#cnauto-resources.Resources#  @resources:rowcount;noquote@</h1>
<if @resources:rowcount@ gt 0>
  <listtemplate name="resources"></listtemplate> 
</if>
