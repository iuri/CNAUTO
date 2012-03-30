<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<table width="100%" cellpadding="0" cellspacing="0"> 
  <tr>
    <td align="left" valign="top">
      <ul style="list-style:none;">
        <li style="list-style:none; display:inline;"><a href="vehicles-import-csv-file?return_url=@return_url@">#cnauto-resources.Import_vehicles#</a> |</li> 
        <li style="list-style:none; display:inline;"><a href="@vehicle_ae_url@">#cnauto-resources.Add_vehicle#</a> | </li>
        <if @admin_p@>
          <li  style="list-style:none; display:inline;"><a href="@admin_url@">#cnauto-resources.Admin#</a> </li>
        </if>
      </ul>
    </td>
    <td align="right" valign="top">
      <br \>
      <form name="search" method="post">
        <input type="text" name="keyword" id="keyword" value="chassis">
	<input type="submit" name="submit" id="submit" value="#cnauto-core.Search#">
      </form>
    </td>
  </tr>
</table>

<h1>#cnauto-resources.Vehicles#</h1>
<listtemplate name="vehicles"></listtemplate> 
