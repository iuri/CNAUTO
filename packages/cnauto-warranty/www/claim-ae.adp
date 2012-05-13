<master>

<property name="title">@page_title;noquote@</property>
<property name="context">{@page_title;noquote@}</property>

<h1>@page_title;noquote@</h1>

<form name="claim_ae" action="claim-ae" method="post">
<input type="hidden" id="claim_id" name="claim_id" value="@claim_id@">
 
<table>
  <tr>
    <td>#cnauto-warranty.Chassis#</td>
    <td>@vehicle_select_html;noquote@</td>
    <td>#cnauto-warranty.Model#</td>
    <td>@resource_select_html;noquote@</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  <tr>
    <td>#cnauto-warranty.Year#</td>
    <td>
         <input type="text" readonly="readonly" name="yom" id="yom" value="@year;noquote@">  
    </td>
    <td>#cnauto-warranty.Purchase_date#</td>
    <td>@purchase_date_html;noquote@</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>#cnauto-warranty.Owner#</td>
    <td>@owner_select_html;noquote@</td>
    <td>#cnauto-warranty.Distributor#</td>
    <td>@distributor_select_html;noquote@</td>
    <td>#cnauto-warranty.Code#</td>
    <td><input type="text" readonly="readonly" name="code" value="@code;noquote@"></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>#cnauto-warranty.Claim_number#</td>
    <td><input type="text" readonly="readonly" name="claim_number" id="claim_number" value="@claim_number@"></td>
    <td>#cnauto-warranty.Claim_date#</td>
    <td width="50%">
        <!-- date purchase_date begin -->
    	@claim_date_html;noquote@
        <!-- date purchase_date end -->
    </td>
    <td>#cnauto-warranty.KM#</td>
    <td>
        <input type="text" name="km" id="km" value="@km@">  
    </td>
  </tr>
  <tr>
        <td>#cnauto-warranty.Service_order#</td>
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
    <td valign="top" align="right"><input type=submit name=cancel.x value=#cnauto-warranty.Cancel#></td>
  </tr>

</table>
</form>