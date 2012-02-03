<master>

<property name="title">@page_title;noquote@</property>
<property name="context">{@page_title;noquote@}</property>

<h1>@page_title;noquote@</h1>

<form name="assurance_ae" action="" method="post">
<table>
  <tr>
    <td>#cnauto-import.Distributor#</td>
    <td>
      <select name="distributor_id" id="distributor_id">
        <option value="0">#cnauto-import.Select#</option>
        @distributor_options_html;noquote@  
      </select>
    </td>
    <td>#cnauto-import.Code#</td>
    <td><input type="text" name="code" value=""></td>
  </tr>
  <tr>
    <td>#cnauto-import.Client#</td>
    <td>
      <select name="client_id" id="client_id">
        <option value="0">#cnauto-import.Select#</option>
        @client_options_html;noquote@  
      </select>
    </td>
  </tr>
  <tr>
    <td>#cnauto-import.Chassis#</td>
    <td>
      <select name="vehicle_id" id="vehicle_id">
        <option value="0">#cnauto-import.Select#</option>
        @vehicle_options_html;noquote@  
      </select>
    </td>
  </tr>


</table>
</form>