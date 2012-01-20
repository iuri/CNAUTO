<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>


<a href="persons-import-csv-file?return_url=@return_url@">#cn-resources.Import_persons#</a> 
<a href="@person_ae_url@">#cn-resources.Add_Edit_persons#</a> 

<if @admin_p@>
  <a href="@admin_url@">#cn-resources.Admin#</a> 
</if>

<formtemplate id="search"></formtemplate>
<if @persons:rowcount@ gt 0>
  <listtemplate name="persons"></listtemplate> 
</if>
