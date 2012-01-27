<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>


<a href="persons-import-csv-file?return_url=@return_url@">#cnauto-resources.Import_persons#</a> 
<a href="@person_ae_url@">#cnauto-resources.Add_person#</a> 

<if @admin_p@>
  <a href="@admin_url@">#cnauto-resources.Admin#</a> 
</if>

<formtemplate id="search"></formtemplate>
<if @persons:rowcount@ gt 0>
  <listtemplate name="persons"></listtemplate> 
</if>
