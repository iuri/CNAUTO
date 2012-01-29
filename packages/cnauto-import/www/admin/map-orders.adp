<master>

<property name="title">@title;noquote@</property>
<property name="name">@context;noquote@</property>


<h1>@title;noquote@</h1>
<form name="map-orders" action="map-orders-2" method="post">
<table width="100%">
  <tr>
    <td valign="top" align="left">
      <table>
        <tr>	
    	  <td>&nbsp;</td>
	    <if @steps:rowcount@ gt 0>
	      <multiple name="steps">
	        <td><a href="workflow-ae"><b>@steps.step;noquote@</b></a></td>
	      </multiple>
	    </if>
	</tr>
	@html;noquote@
      </table>
    </td>
  </tr>
  <tr>
    <td valign="top" align="right">
      <input type="hidden" name="workflow_id" value="@workflow_id@">
      <input type="hidden" name="return_url" value="@return_url@">
      <input type="submit" name="submit" value="#cnauto-import.Save#">
    </td>
  </tr>
</table>
</form>