<master>

<property name="title">@page_title;noquote@</property>
<property name="context">{@page_title;noquote@}</property>

<h1>@page_title;noquote@</h1>
<a href="@assign_asset_url@">#cnauto-resources.Assign_to_user#</a> <br>
<formtemplate id="asset_one"></formtemplate>
<input type="button" value="Edit" onclick="javascript:parent.location='@asset_ae_url@'" />
<input type="button" value="Cancel" onclick="javascript:parent.location='@return_url@'" />
