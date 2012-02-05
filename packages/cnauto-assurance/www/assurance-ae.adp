<master>

<property name="title">@page_title;noquote@</property>
<property name="context">{@page_title;noquote@}</property>

<h1>@page_title;noquote@</h1>

<form name="assurance_ae" action="" method="post">
<table>
  <tr>
    <td>#cnauto-import.Chassis#</td>
    <td>
      <select name="vehicleList" id="vehicleList" onChange="return VehicleListOnChange()">
        <option value="0">#cnauto-import.Select#</option>
        @vehicle_options_html;noquote@  
      </select>
    </td>
  </tr>
  <tr>
    <td>#cnauto-import.Distributor#</td>
    <td>
      <select name="distributorList" id="distributorList">
      </select>
    </td>
x    <td>#cnauto-import.Code#</td>
    <td><input type="text" name="code" value=""></td>
  </tr>
  <tr>
    <td>#cnauto-import.Client#</td>
    <td>
      <select name="ownerList" id="ownerList">
      </select>
    </td>
  </tr>
  <tr>
    <td>#cnauto-import.Vehicle#</td>
    <td>
        <input type="text" name="resource" id="resource">  
    </td>
    <td>#cnauto-import.Model#</td>
    <td>
        <input type="text" name="model" id="model">  
    </td>
    <td>#cnauto-import.Year#</td>
    <td>
        <input type="text" name="yom" id="yom">  
    </td>
  </tr>


</table>
</form>