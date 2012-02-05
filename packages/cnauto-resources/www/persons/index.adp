<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<ul>
<li><a href="persons-import-csv-file?return_url=@return_url@">#cnauto-resources.Import_persons#</a> </li>
<li><a href="@person_ae_url@">#cnauto-resources.Add_person#</a> </li>

<if @admin_p@>
  <li><a href="@admin_url@">#cnauto-resources.Admin#</a></ul> 
</if>
</ul>
<formtemplate id="search"></formtemplate>
<if @persons:rowcount@ gt 0>
  <listtemplate name="persons"></listtemplate> 
</if>
