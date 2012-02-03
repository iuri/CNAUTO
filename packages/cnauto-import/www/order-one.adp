<master>

<property name="title">@title;noquote@</property>
<property name="name">@context;noquote@</property>


<h1>@title;noquote@</h1>

<table>
<tr><td>&nbsp;</td></tr>

<br><br>


<if @steps:rowcount@ gt 0>
  <tr>  
    <multiple name="steps">
      <td><a href="@steps.step_order_url@"><b>@steps.pretty_name;noquote@</b></a></td>
    </multiple>
  </tr>
</if>
<else>
  <tr><td>#cnauto-import.There_are_no_lt# <a href="@map_order_url@">#cnauto-import.Click_here#</a></td></tr>
</else>


<if @columns:rowcount@ gt 0>
  <tr>
    <multiple name="columns">
      <td>
        <if @columns.sort_order@ eq 0>
      	  <table border=1>
            <tr>
              <td>@code@ </td>
	      <td>#cnauto-import.Provider#</td>
	      <td>@incoterm@</td>
	    </tr>
	    <tr>
	      <td>@creation_date@</td>
	      <td>@provider@</td>
	      <td>@incoterm_value@</td>
	    </tr>
	  </table>	      
        </if>
	<else>
	  <table border=1>
            <tr>
              <td>&nbsp;</td>
              <td>@columns.department_id@</td>
            </tr>
            <tr>
              <td>&nbsp;</td>
              <td>@columns.assignee_id@</td>
            </tr>
            <tr>
              <td>#cnauto-import.Estimated_date#</td>
              <td>@columns.estimated_date@</td>
            </tr>
            <tr>
              <td>#cnauto-import.Executed_date#</td>
              <td>@columns.executed_date@</td>
            </tr>
          </table>
        </else>
      </td>
    </multiple>
  </tr>
</if>
</table>