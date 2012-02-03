<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

 
<ul>
  <li>  <a href="persons/">#cnauto-resources.Persons#</a> </li>
  <li><a href="vehicles/">#cnauto-resources.Vehicles#</a> </li>
  <li>  <a href="resource-ae">#cnauto-resources.Add_resource#</a> </li>

<if @admin_p@>
  <li><a href="@admin_url@">#cnauto-resources.Admin#</a> </li>
</if>
</ul>


<formtemplate id="search"></formtemplate>
<if @resources:rowcount@ gt 0>
  <listtemplate name="resources"></listtemplate> 
</if>
