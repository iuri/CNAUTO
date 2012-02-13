<master>

<property name="title">@title;noquote@</property>
<property name="context">{@title;noquote@}</property>

<br />
<h1>#cnauto-assurance.Assurance# # @assurance_number;noquote@</h1>

<form name="assurance_ae_2" action="assurance-ae-2" method="post">

<h2>@title;noquote@</h2>

<table>
  <tr>
    <td>
      <table border=1>
        <tr>
    	  <td>#cnauto-assurance.Code#</td>
    	  <td>#cnauto-assurance.Description#</td>
    	  <td>#cnauto-assurance.Unit_cost#</td>
    	  <td>#cnauto-assurance.Quantity#</td>
    	  <td>#cnauto-assurance.Incomes#</td>
    	  <td>#cnauto-assurance.Assurance_cost#</td>
    	  <td>#cnauto-assurance.MO_code#</td>
    	  <td>#cnauto-assurance.MO_time#</td>
    	  <td>#cnauto-assurance.Third_services#</td>
    	</tr>
        <multiple name="parts">
	  <tr>
    	  <td>
            <input type="text" size="15" name="part_code.@parts.i@" id="part_code.@parts.i@">
          </td>
	  <td>
            <input type="text" name="part_name.@parts.i@" id="part_name.@parts.i@">
          </td>
    	  <td>
            <input type="numeric" size="10" name="part_cost.@parts.i@" id="part_cost.@parts.i@">
          </td>
    	  <td>
             <input type="text" size="5" name="part_quantity.@parts.i@" id="part_quantity.@parts.i@">
          </td>
    	  <td>
            <input type="text" size="10" name="part_incomes.@parts.i@" id="part_incomes.@parts.i@">
          </td>
    	  <td>
            <input type="text" readonly="readonly" size="10" name="assurance_cost.@parts.i@" id="assurance_cost.@parts.i@">
          </td>
    	  <td>
            <input type="text" size="10" name="mo_code.@parts.i@" id="mo_code.@parts.i@">
          </td>
    	  <td>
            <input type="text" size="5" name="mo_time.@parts.i@" id="mo_time.@parts.i@">
          </td>
    	  <td>
            <input type="text" size="10" name="third_cost.@parts.i@" id="third_cost.@parts.i@"  onChange="return FillFieldsOnChange(@parts.i@)">
          </td>
	</tr>
	

        </multiple>
      </table>
    </td>
  </tr>
  <tr>
    <td>#cnauto-assurance.Diagnostics_Solution#</td>
  </tr>
  <tr>
    <td><textarea rows="5" cols="100" name="description" id="description"></textarea></td>
  </tr>
</table>
<table>
  <tr>
    <td>#cnauto-assurance.Parts_total_cost#</td>
    <td><input type="text" readonly="readonly" name="parts_total_cost" id="parts_total_cost"></td>
    <td>#cnauto-assurance.third_total_cost#</td>
    <td><input type="text" readonly="readonly" name="third_total_cost" id="third_total_cost"></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>#cnauto-assurance.Assurance_total_cost#</td>
    <td><input type="text" readonly="readonly" name="assurance_total_cost" id="assurance_total_cost"></td>
    <td>#cnauto-assurance.MO_total_cost#</td>
    <td><input type="text" readonly="readonly" name="mo_total_cost" id="mo_total_cost"></td>
    <td>#cnauto-assurance.Total_cost#</td>
    <td><input type="text" readonly="readonly" name="total_cost" id="total_cost"></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td valign="top" align="right">
      <input type="hidden" name="assurance_id" id="assurance_id" value="@assurance_id@"> 
      <input type=submit name=submit.x value=#cnauto-assurance.New#>
      <input type=submit name=cancel.x value=#cnauto-assurance.Cancel#>
    </td>
  </tr>
</table>