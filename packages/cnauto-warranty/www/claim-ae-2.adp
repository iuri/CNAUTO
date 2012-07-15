<master>

<property name="title">@title;noquote@</property>
<property name="context">{@title;noquote@}</property>

<br />
<h1>#cnauto-warranty.Warranty# # @claim_number;noquote@</h1>

<form name="claim_ae_2" action="claim-ae-2" method="post" enctype="multipart/form-data">

<h2>@title;noquote@</h2>

<table>
  <tr>
    <td>
      <table border=1>
        <tr>
    	  <td>#cnauto-warranty.Code#</td>
    	  <td>#cnauto-warranty.Description#</td>
    	  <td>#cnauto-warranty.Unit_cost#</td>
    	  <td>#cnauto-warranty.Quantity#</td>
    	  <td>#cnauto-warranty.Incomes#</td>
    	  <td>#cnauto-warranty.Claim_cost#</td>
    	  <td>#cnauto-warranty.MO_code#</td>
    	  <td>#cnauto-warranty.MO_time#</td>
    	  <td>#cnauto-warranty.Third_services#</td>
	  <td>&nbsp;</td>
    	</tr>
	<if parts.rowcount gt 0>
	<multiple name="parts">
        <tr>
    	  <td>
            <input type="text" size="15" name="code" id="code">
 	    <div id="hint"></div>
	    <script type="text/javascript"> new Ajax.Autocompleter("code","hint","autocomplete-parts"); </script>
          </td>
	  <td>
            <input type="text" name="pretty_name" id="pretty_name">
          </td>
    	  <td>
            <input type="numeric" size="10" name="part_cost" id="part_cost">
          </td>
    	  <td>
             <input type="text" size="5" name="quantity" id="quantity">
          </td>
    	  <td>
            <input type="text" size="10" name="incomes" id="incomes">
          </td>
    	  <td>
            <input type="text" readonly="readonly" size="10" name="claim_cost" id="claim_cost">
          </td>
    	  <td>
            <input type="text" size="10" name="mo_code" id="mo_code">
          </td>
    	  <td>
            <input type="text" size="5" name="mo_time" id="mo_time">
          </td>
    	  <td><input type="text" size="10" name="third_cost" id="third_cost" onChange="return FillFieldsOnChange(@code@)">
          </td>
	  <td>&nbsp;</td>
	</tr>
        </multiple>
        </if>
        <tr>
    	  <td>
            <input type="text" size="15" name="code" id="code">
 	    <div id="hint"></div>
	    <script type="text/javascript"> new Ajax.Autocompleter("code","hint","autocomplete-parts"); </script>
          </td>
	  <td>
            <input type="text" name="pretty_name" id="pretty_name">
          </td>
    	  <td>
            <input type="numeric" size="10" name="part_cost" id="part_cost">
          </td>
    	  <td>
             <input type="text" size="5" name="quantity" id="quantity">
          </td>
    	  <td>
            <input type="text" size="10" name="incomes" id="incomes">
          </td>
    	  <td>
            <input type="text" readonly="readonly" size="10" name="claim_cost" id="claim_cost">
          </td>
    	  <td>
            <input type="text" size="10" name="mo_code" id="mo_code">
          </td>
    	  <td>
            <input type="text" size="5" name="mo_time" id="mo_time">
          </td>
    	  <td><input type="text" size="10" name="third_cost" id="third_cost" onChange="return FillFieldsOnChange(@code@)">
          </td>
	  <td><input type=submit name="submit.x" value="#cnauto-warranty.Plus#"></td>
	</tr>


      </table>
    </td>
  </tr>
  <tr>
    <td>#cnauto-warranty.Diagnostics_Solution#</td>
  </tr>
  <tr>
    <td><textarea rows="5" cols="100" name="description" id="description" value="@description;noquote@"></textarea></td>
  </tr>
</table>
<table>
  <tr>
    <td>#cnauto-warranty.Parts_total_cost#</td>
    <td><input type="text" readonly="readonly" name="parts_total_cost" id="parts_total_cost" value="@parts_total_cost@"></td>
    <td>#cnauto-warranty.third_total_cost#</td>
    <td><input type="text" readonly="readonly" name="third_total_cost" id="third_total_cost" value="@third_total_cost@"></td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>#cnauto-warranty.claim_total_cost#</td>
    <td><input type="text" readonly="readonly" name="claim_total_cost" id="claim_total_cost" value="@claim_total_cost@"></td>
    <td>#cnauto-warranty.MO_total_cost#</td>
    <td><input type="text" readonly="readonly" name="mo_total_cost" id="mo_total_cost" value="@mo_total_cost@"></td>
    <td>#cnauto-warranty.Total_cost#</td>
    <td><input type="text" readonly="readonly" name="total_cost" id="total_cost" value="@total_cost@"></td>
  </tr>
</table>
<table width="100%" cellpadding="0" cellspacing="0">
  <if files.rowcount gt 0>
    <tr>
      <td><h1>cnauto-warranty.Attached_files</h1></td> 
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
      <a href="#" class="show_hide">#cnauto-warranty.attach_image#</a>
      <div class="slidingDiv">
          <input type="file" name="upload_file" id="upload_file" size="40">
	  <input type="submit" name="submit.file" id="submit.file" value="#cnauto-warranty.Save#">
      </div>
    </td>
  </tr>

  <tr>
    <td valign="top" align="right">
      <input type="hidden" name="claim_id" id="claim_id" value="@claim_id@"> 
      <input type=submit name="submit.x" value="#cnauto-warranty.Save#">
      <input type=submit name="cancel.x" value="#cnauto-warranty.Cancel#">
    </td>
  </tr>
</table>
</form>