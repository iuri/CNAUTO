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
      <td><a href="workflow-ae"><b>@steps.step;noquote@</b></a></td>
    </multiple>
  </tr>
</if>
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
	    <multiple name="columns">
              <tr>
                <td>&nbsp;</td>
                <td>@order.department_id@</td>
              </tr>
              <tr>
                  <td></td>
                  <td>@order.assignee_id@</td>
              </tr>
              <tr>
                  <td>#cnauto-inmport.Estimated_date#</td>
                  <td>@order.estimated_date@</td>
              </tr>
              <tr>
                  <td>#cnauto-import.Executed_date#</td>
                  <td>@order.executed_date@</td>
              </tr>
	    </multiple>
          </table>
        </else>
      </td>
    </multiple>
  </tr>
</if>
</table>