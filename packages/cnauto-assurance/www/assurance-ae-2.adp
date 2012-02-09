<master>

<property name="title">@title;noquote@</property>
<property name="context">{@title;noquote@}</property>

<h1>@title;noquote@</h1>

<form name="assurance_ae_2" action="assurance-ae-3" method="post">

<table>
  <tr>
    <td>
      <table border=1>
        <tr>
    	  <td>#cnauto-assurance.Code#</td>
    	  <td>#cnauto-assurance.Pretty_name#</td>
    	  <td>#cnauto-assurance.Cost#</td>
    	  <td>#cnauto-assurance.Quantity#</td>
    	  <td>#cnauto-assurance.Oil_Incomes#</td>
    	  <td>#cnauto-assurance.Assurance_cost#</td>
    	  <td>#cnauto-assurance.MO_code#</td>
    	  <td>#cnauto-assurance.MO_time#</td>
    	  <td>#cnauto-assurance.Third_services#</td>
    	</tr>
	@parts_html;noquote@
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