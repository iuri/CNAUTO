<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

 
<a href="persons/">#cnauto-resources.Persons#</a> 
<a href="vehicles/">#cnauto-resources.Vehicles#</a> 

<if @admin_p@>
  <a href="@admin_url@">#cnauto-resources.Admin#</a> 
</if>


<formtemplate id="search"></formtemplate>
<if @resources:rowcount@ gt 0>
  <listtemplate name="resources"></listtemplate> 
</if>
