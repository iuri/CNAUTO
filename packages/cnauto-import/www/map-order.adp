<master>

<property name="title">@title;noquote@</property>
<property name="name">@context;noquote@</property>


<h1>@title;noquote@</h1>

<a href="@map_url@">Map Order to Workflow</a>
<table>
  <tr>
    <td>&nbsp;</td>
    <if @steps:rowcount@ gt 0>
      <multiple name="steps">
        <td><a href="workflow-ae"><b>@steps.step;noquote@</b></a></td>
      </multiple>
    </if>
  </tr>

<form name="map-order" action="map-order-2" method="post"> 
<if @orders:rowcount@ gt 0>
  <multiple name="orders"> 
    <tr>  
      <td><a href="order-ae"><b>@orders.code;noquote@</b></a></td>
      <multiple name="steps">
        <td>
	  <if @orders.mapped_p@ eq 1>
	    tet
	    <input type="checkbox" value="@orders.order_id@" name="maps.@steps.step_id@" checked>
	  </if> 
	  <else>
            test
	    <input type="checkbox" value="@orders.order_id@" name="maps.@steps.step_id@">
	  </else>
	</td>
      </multiple>
    </tr>
  </multiple>
</if>


<tr><td>
	<input type="hidden" name="workflow_id" value="@workflow_id@">
	<input type="submit" name="submit" value="#cnauto-import.Save#"></td></tr>
</form>
</table>
