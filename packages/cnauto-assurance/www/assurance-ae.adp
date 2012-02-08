<master>

<property name="title">@page_title;noquote@</property>
<property name="context">{@page_title;noquote@}</property>

<h1>@page_title;noquote@</h1>

<form name="assurance_ae" action="assurance-ae2" method="post">
<table>
  <tr>
    <td>#cnauto-assurance.Chassis#</td>
    <td>@vehicle_select_html;noquote@</td>
    <td>#cnauto-assurance.Model#</td>
    <td>@model_select_html;noquote@</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  <tr>
    <td>#cnauto-assurance.Purchase_date#</td>
    <td>@purchase_date_html;noquote@</td>
    <td>#cnauto-assurance.KM#</td>
    <td>
        <input type="text" name="km" id="km">  
    </td>
    <td>#cnauto-assurance.Year#</td>
    <td>
        <input type="text" name="yom" id="yom">  
    </td>
  </tr>
  <tr>
    <td>#cnauto-assurance.Distributor#</td>
    <td>@distributor_select_html;noquote@</td>
    <td>#cnauto-assurance.Code#</td>
    <td><input type="text" name="code" value=""></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>#cnauto-assurance.Owner#</td>
    <td>@owner_select_html;noquote@</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>#cnauto-assurance.Assurance_number#</td>
    <td><input type="text" name="assurance_number" id="assurance_number" value="@assurance_number@"></td>
    <td>#cnauto-assurance.Assurance_date#</td>
    <td width="50%">
        <!-- date purchase_date begin -->
    	@assurance_date_html;noquote@
        <!-- date purchase_date end -->
    </td>
  </tr>
  <tr>
        <td>#cnauto-assurance.Service_order_number#</td>
    <td><input type="date" name="servcice_order_number" id="service_order_number"></td>

  </tr>
</table>

<table>
  <tr>
    <td>#cnauto-assurance.Parts#</td>
  </tr>
  <tr>
    <td> <include src="/packages/cnauto-assurance/lib/parts-grid"></td>  
  </tr>

  <tr>
    <td>
      <table border=1>
        <tr>
    	  <td>#cnauto-assurance.Pretty_name#</td>
    	  <td>#cnauto-assurance.Code#</td>
    	  <td>#cnauto-assurance.Cost#</td>
    	  <td>#cnauto-assurance.Quantity#</td>
    	  <td>#cnauto-assurance.Oil_Incomes#</td>
    	  <td>#cnauto-assurance.Assurance_cost#</td>
    	  <td>#cnauto-assurance.MO_code#</td>
    	  <td>#cnauto-assurance.MO_time#</td>
    	  <td>#cnauto-assurance.Third_services#</td>
    	</tr>
	<tr>
	  <td><input type="text" name="part_name" id="part_name"></td>
    	  <td><input type="text" name="part_code" id="part_code"></td>
    	  <td><input type="text" name="part_cost" id="part_cost"></td>
    	  <td><input type="text" name="part_quantity" id="parts_quantity"></td>
    	  <td><input type="text" name="part_incomes" id="part_incomes"></td>
    	  <td><input type="text" name="part_assurance_cost" id="part_assurance_cost"></td>
    	  <td><input type="text" name="part_mo_code" id="part_mo_code"></td>
    	  <td><input type="text" name="part_mo_time" id="part_mo_time"></td>
    	  <td><input type="text" name="part_third_cost" id="part_third_cost"></td>
    	</tr>
	<tr>
	  <td><input type="text" name="part_name" id="part_name"></td>
    	  <td><input type="text" name="part_code" id="part_code"></td>
    	  <td><input type="text" name="part_cost" id="part_cost"></td>
    	  <td><input type="text" name="part_quantity" id="parts_quantity"></td>
    	  <td><input type="text" name="part_incomes" id="part_incomes"></td>
    	  <td><input type="text" name="part_assurance_cost" id="part_assurance_cost"></td>
    	  <td><input type="text" name="part_mo_code" id="part_mo_code"></td>
    	  <td><input type="text" name="part_mo_time" id="part_mo_time"></td>
    	  <td><input type="text" name="part_third_cost" id="part_third_cost"></td>
	</tr>
	<tr>
	  <td><input type="text" name="part_name" id="part_name"></td>
    	  <td><input type="text" name="part_code" id="part_code"></td>
    	  <td><input type="text" name="part_cost" id="part_cost"></td>
    	  <td><input type="text" name="part_quantity" id="parts_quantity"></td>
    	  <td><input type="text" name="part_incomes" id="part_incomes"></td>
    	  <td><input type="text" name="part_assurance_cost" id="part_assurance_cost"></td>
    	  <td><input type="text" name="part_mo_code" id="part_mo_code"></td>
    	  <td><input type="text" name="part_mo_time" id="part_mo_time"></td>
    	  <td><input type="text" name="part_third_cost" id="part_third_cost"></td>
	</tr>
	<tr>
	  <td><input type="text" name="part_name" id="part_name"></td>
    	  <td><input type="text" name="part_code" id="part_code"></td>
    	  <td><input type="text" name="part_cost" id="part_cost"></td>
    	  <td><input type="text" name="part_quantity" id="parts_quantity"></td>
    	  <td><input type="text" name="part_incomes" id="part_incomes"></td>
    	  <td><input type="text" name="part_assurance_cost" id="part_assurance_cost"></td>
    	  <td><input type="text" name="part_mo_code" id="part_mo_code"></td>
    	  <td><input type="text" name="part_mo_time" id="part_mo_time"></td>
    	  <td><input type="text" name="part_third_cost" id="part_third_cost"></td>
	</tr>
      </table>
    </td>
  </tr>
  <tr>
    <td>#cnauto-assurance.Diagnostics_Solution#</td>
  </tr>
  <tr>
    <td><textarea rows="5" cols="200" name="description" id="description"></textarea></td>
  </tr>
</table>
<table>
  <tr>
    <td>#cnauto-assurance.Parts_total_cost#</td>
    <td><input type="text" name="parts_cost" id="parts_cost"></td>
    <td>&nbsp;</td>
    <td>#cnauto-assurance.third_total_cost#</td>
    <td><input type="text" name="third_cost" id="third_cost"></td>
    <td>#cnauto-assurance.MO_total_cost#</td>
    <td><input type="text" name="mo_cost" id="mo_cost"></td>
  </tr>
  <tr>
    <td>#cnauto-assurance.Assurance_cost#</td>
    <td><input type="text" name="assurance_cost" id="assurance_cost"></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>#cnauto-assurance.Total_cost#</td>
    <td><input type="text" name="total_cost" id="total_cost"></td>
  </tr>
</table>
<table>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td valign="top" align="right"><input type=submit name=submit.x value=#cnauto-assurance.New#></td>
    <td valign="top" align="right"><input type=submit name=cancel.x value=#cnauto-assurance.Cancel#></td>
  </tr>
</table>
</form>