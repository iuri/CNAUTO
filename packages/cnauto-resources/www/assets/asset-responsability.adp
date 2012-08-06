<master>
<br><br>
<h1>#cnauto-resources.Asset_user_matrix#</h1>

<table border="1">
  <tr>
    <td>Users \ Assets</td>
    <multiple name="columns">
      <td>#cnauto-resources.Asset# @columns.count@</td>
    </multiple>    
  </tr>
  <multiple name="rows">
    <tr>
      <td>@rows.user@</td>
      <td>@rows.asset@ <br> @rows.code@ <br> @rows.sn@</td>
     </tr>
  </multiple>
</table>