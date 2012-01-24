<master>

<property name="title">@title;noquote@</property>
<property name="name">@context;noquote@</property>


<h1>@title;noquote@</h1>

<a href="@map_url@">Map Order to Workflow</a>
<table>
<tr><td>&nbsp;</td></tr>

<br><br>


<if @steps:rowcount@ gt 0>
  <tr>  
    <multiple name="steps">
      <td>
        <table>
	  <tr><td><a href="workflow-ae"><b>@steps.step;noquote@</b></a></td></tr>
          <tr><td>
	    <if @steps.sort_order@ eq 0>
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
                  <td></td>
                  <td>@steps.department_id@</td>
                </tr>
                <tr>
                  <td></td>
                  <td>@steps.assignee_id@</td>
                </tr>
                <tr>
                  <td>#cnauto-inmport.Estimated_date#</td>
                  <td>@steps.estimated_date@</td>
                </tr>
                <tr>
                  <td>#cnauto-import.Executed_date#</td>
                  <td>@steps.executed_date@</td>
                </tr>
              </table>
            </else>
          </td></tr>      
        </table>
      </td>
    </multiple>
  </tr>
</if>

<tr><td>&nbsp;</td></tr>
</table>