<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<h1>#cnauto-resources.Parts# @parts:rowcount;noquote@</h1>

<ul> 
  <li><a href="@part_ae_url@">#cnauto-resources.Add_part#</a> </li>

<if @admin_p@>
  <li><a href="@admin_url@">#cnauto-resources.Admin#</a> </li>
  <li><a href="import-parts?return_url=@return_url@">#cnauto-resources.Import_parts#</a> |</li> 
</if>
</ul>

<formtemplate id="search"></formtemplate>
<if @parts:rowcount@ gt 0>
  <listtemplate name="parts"></listtemplate> 
</if>
