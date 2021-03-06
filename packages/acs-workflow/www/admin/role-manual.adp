<master>
<property name="title">Manually Assign @role_name;noquote@</property>
<property name="context">@context;noquote@</property>
<property name="focus">manual_form.transition_key</property>

<form action="role-manual-2" name="manual_form" method="post">
@export_vars;noquote@

<table>
  <tr>
    <th>
      Select the task that you want to assign the @role_name@ role:
    </th>
  </tr>
  <tr>
    <td align="center">
      <select name="transition_key" size="10">
         <multiple name="transitions">
           <option value="@transitions.transition_key@">@transitions.transition_name@</option>
         </multiple>
      </select>
    </td>
  </tr>
  <tr>
    <td align="center">
      <input type="submit" name="submit" value="Proceed" />
      &nbsp; &nbsp; &nbsp;
      <input type="submit" name="cancel" value="Cancel" />
    </td>
  </tr>
</table>

</form>

</master>
