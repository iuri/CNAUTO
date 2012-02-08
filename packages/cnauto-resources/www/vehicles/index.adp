<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>


<ul>
<li><a href="vehicles-import-csv-file?return_url=@return_url@">#cn-resources.Import_vehicles#</a></li> 
<li><a href="@vehicle_ae_url@">#cnauto-resources.Add_vehicle#</a> </li>
<li> <a href="vehicle-models#><#cnauto-resources.Models#</a></li>
<if @admin_p@>
<li>  <a href="@admin_url@">#cn-resources.Admin#</a> </li>
</if>
</ul>
<formtemplate id="search"></formtemplate>
  <listtemplate name="vehicles"></listtemplate> 
<if @vehicles:rowcount@ gt 0>
</if>
