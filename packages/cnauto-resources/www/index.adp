<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

 
<a href="persons/">#cn-resources.Persons#</a> 
<a href="vehicles/">#cn-resources.Vehicles#</a> 

<if @admin_p@>
  <a href="@admin_url@">#cn-resources.Admin#</a> 
</if>


<formtemplate id="search"></formtemplate>
<if @resources:rowcount@ gt 0>
  <listtemplate name="resources"></listtemplate> 
</if>
