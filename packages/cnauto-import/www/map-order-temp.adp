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
      <td><a href="@orders.order_url@"><b>@orders.code;noquote@</b></a></td>
      <%
 
   foreach step_id @orders.step_ids@ {
      	   
	#ns_log Notice "$order_id | $step_id | $workflow_id"
	set id @orders.order_id@
	set mapped_p [db_0or1row select_map_id {
	    SELECT map_id FROM cn_workflow_step_order_map wsom
	    WHERE wsom.step_id = :step_id
	    AND order_id = :id
	}]
	ns_log Notice "MAPPED $mapped_p"
   
%>
        <td>
	  <if @mapped_p@ eq 1>
	    <input type="checkbox" value="@orders.order_id@" name="maps.@steps.step_id@" checked>
	  </if> 
	  <else>
	    <input type="checkbox" value="@orders.order_id@" name="maps.@steps.step_id@">
	  </else>
	</td>
<% } %>
    </tr>
  </multiple>
</if>


<tr><td>
	<input type="hidden" name="workflow_id" value="@workflow_id@">
	<input type="submit" name="submit" value="#cnauto-import.Save#"></td></tr>
</form>
</table>
