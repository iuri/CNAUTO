<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>


<a href="vehicles-import-csv-file?return_url=@return_url@">#cn-resources.Import_vehicles#</a> 
<a href="@vehicle_ae_url@">#cn-resources.Add_Edit_vehicle#</a> 

<if @admin_p@>
  <a href="@admin_url@">#cn-resources.Admin#</a> 
</if>

<formtemplate id="search"></formtemplate>
  <listtemplate name="vehicles"></listtemplate> 
<if @vehicles:rowcount@ gt 0>
</if>
