<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<table width="100%" cellpadding="0" cellspacing="0">
  <tr>
    <td align="top" valign="left">
      <ul>
        <if @admin_p@>
          <li  style="list-style:none; display:inline;">  <a href="asset-ae">#cnauto-resources.Add_asset#</a> </li>
          <li  style="list-style:none; display:inline;">  <a href="asset-responsability">#cnauto-resources.Asset_responsability#</a> </li>
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

<if @assets:rowcount@ gt 0>
<h1>#cnauto-resources.Assets#</h1>
  <listtemplate name="assets"></listtemplate> 
</if>
