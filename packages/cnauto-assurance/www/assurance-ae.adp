<master>

<property name="title">@page_title;noquote@</property>
<property name="context">{@page_title;noquote@}</property>

<h1>@page_title;noquote@</h1>

<form name="assurance_ae" action="assurance-ae" method="post">
<input type="hidden" name="assurance_id" id="assurance_id" value="@assurance_id@">
<table>
  <tr>
    <td>#cnauto-assurance.Chassis#</td>
    <td>@vehicle_select_html;noquote@</td>
    <td>#cnauto-assurance.Model#</td>
    <td>@model_select_html;noquote@</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  <tr>
    <td>#cnauto-assurance.Year#</td>
    <td>
         <input type="text" readonly="readonly" name="yom" id="yom" value="@year;noquote@">  
    </td>
    <td>#cnauto-assurance.Purchase_date#</td>
    <td>@purchase_date_html;noquote@</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>#cnauto-assurance.Owner#</td>
    <td>@owner_select_html;noquote@</td>
    <td>#cnauto-assurance.Distributor#</td>
    <td>@distributor_select_html;noquote@</td>
    <td>#cnauto-assurance.Code#</td>
    <td><input type="text" readonly="readonly" name="code" value="@code;noquote@"></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>#cnauto-assurance.Assurance_number#</td>
    <td><input type="text" readonly="readonly" name="assurance_number" id="assurance_number" value="@assurance_number@"></td>
    <td>#cnauto-assurance.Assurance_date#</td>
    <td width="50%">
        <!-- date purchase_date begin -->
    	@assurance_date_html;noquote@
        <!-- date purchase_date end -->
    </td>
    <td>#cnauto-assurance.KM#</td>
    <td>
        <input type="text" name="km" id="km" value="@km@">  
    </td>
  </tr>
  <tr>
        <td>#cnauto-assurance.Service_order#</td>
    <td><input type="text" name="service_order" id="service_order" value="@service_order@"></td>

  </tr>
</table>
<table>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td valign="top" align="right"><input type=submit name=@submit_name@.x value="@submit_value@"></td>
    <td valign="top" align="right"><input type=submit name=cancel.x value=#cnauto-assurance.Cancel#></td>
  </tr>
</table>
</form>