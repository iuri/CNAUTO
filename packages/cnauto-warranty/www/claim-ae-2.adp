<master>

<property name="title">@title;noquote@</property>
<property name="context">{@title;noquote@}</property>

<br />
<h1>#cnauto-assurance.Assurance# # @assurance_number;noquote@</h1>

<form name="assurance_ae_2" action="assurance-ae-2" method="post" enctype="multipart/form-data">

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
            <input type="text" size="15" name="part_code.@parts.i@" id="part_code.@parts.i@" value="@parts.code;noquote@">
          </td>
	  <td>
            <input type="text" name="part_name.@parts.i@" id="part_name.@parts.i@" value="@parts.pretty_name;noquote@">
          </td>
    	  <td>
            <input type="numeric" size="10" name="part_cost.@parts.i@" id="part_cost.@parts.i@" value="@parts.part_cost;noquote@">
          </td>
    	  <td>
             <input type="text" size="5" name="part_quantity.@parts.i@" id="part_quantity.@parts.i@" value="@parts.quantity;noquote@">
          </td>
    	  <td>
            <input type="text" size="10" name="part_incomes.@parts.i@" id="part_incomes.@parts.i@" value="@parts.incomes;noquote@">
          </td>
    	  <td>
            <input type="text" readonly="readonly" size="10" name="assurance_cost.@parts.i@" id="assurance_cost.@parts.i@" value="@parts.assurance_cost;noquote@">
          </td>
    	  <td>
            <input type="text" size="10" name="mo_code.@parts.i@" id="mo_code.@parts.i@" value="@parts.mo_code;noquote@">
          </td>
    	  <td>
            <input type="text" size="5" name="mo_time.@parts.i@" id="mo_time.@parts.i@" value="@parts.mo_time;noquote@">
          </td>
    	  <td>
            <input type="text" size="10" name="third_cost.@parts.i@" id="third_cost.@parts.i@" value="@parts.third_cost;noquote@" onChange="return FillFieldsOnChange(@parts.i@)">
          </td>
	</tr>
        </multiple>
	<tr>
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>
	  <td><a href="@add_more_lines@">More Lines</a></td>
	</tr>
      </table>
    </td>
  </tr>
  <tr>
    <td>#cnauto-assurance.Diagnostics_Solution#</td>
  </tr>
  <tr>
    <td><textarea rows="5" cols="100" name="description" id="description" value="@description;noquote@"></textarea></td>
  </tr>
</table>
<table>
  <tr>
    <td>#cnauto-assurance.Parts_total_cost#</td>
    <td><input type="text" readonly="readonly" name="parts_total_cost" id="parts_total_cost" value="@parts_total_cost@"></td>
    <td>#cnauto-assurance.third_total_cost#</td>
    <td><input type="text" readonly="readonly" name="third_total_cost" id="third_total_cost" value="@third_total_cost@"></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>#cnauto-assurance.Assurance_total_cost#</td>
    <td><input type="text" readonly="readonly" name="assurance_total_cost" id="assurance_total_cost" value="@assurance_total_cost@"></td>
    <td>#cnauto-assurance.MO_total_cost#</td>
    <td><input type="text" readonly="readonly" name="mo_total_cost" id="mo_total_cost" value="@mo_total_cost@"></td>
    <td>#cnauto-assurance.Total_cost#</td>
    <td><input type="text" readonly="readonly" name="total_cost" id="total_cost" value="@total_cost@"></td>
  </tr>
</table>
<table width="100%" cellpadding="0" cellspacing="0">
  <if files.rowcount gt 0>
    <tr>
      <td><h1>cnauto-assurance.Attached_files</h1></td> 
    </tr>
    <tr>
      <multiple name="files">
        <td width="10%"><a href=""><img src="@files.img@"> &nbsp; @files.filename;noquote@</a></td>
      </multiple>
    </tr>
  </if>
  <tr>
    <td>
      @javascript_attach_files;noquote@
      <a href="#" class="show_hide">#cnauto-assurance.attach_image#</a>
      <div class="slidingDiv">
          <input type="file" name="upload_file" id="upload_file" size="40">
	  <input type="submit" name="submit.file" id="submit.file" value="#cnauto-assurance.Save#">
      </div>
    </td>
  </tr>

  <tr>
    <td valign="top" align="right">
      <input type="hidden" name="assurance_id" id="assurance_id" value="@assurance_id@"> 
      <input type=submit name="submit.x" value="#cnauto-assurance.Save#">
      <input type=submit name="cancel.x" value="#cnauto-assurance.Cancel#">
    </td>
  </tr>
</table>
</form>