<master>

<property name="title">@title@</property>

<div class="options_list">
<ul>
	<li><a class="button" href="spreadsheet-items?spreadsheet_id=@spreadsheet_id@" title="#cn-spreadsheet.Items#" alt="#cn-spreadsheet.Items#">#cn-spreadsheet.Items#</a></li>
	<li><a class="button" href="cn-spreadsheet-users-bulk-add?spreadsheet_id=@spreadsheet_id@&return_url=@return_url@" title="#cn-spreadsheet.Upload_list_users#" alt="#cn-spreadsheet.Upload_list_users#">#cn-spreadsheet.Upload_list_users#</a></li>
	<li><a class="button" href="spreadsheet-fields?spreadsheet_id=@spreadsheet_id@">#cn-spreadsheet.Fields#</a></li>
	<li><a class="button" href="spreadsheet-emails-export?spreadsheet_id=@spreadsheet_id@">#cn-spreadsheet.Export_data#</a></li>
</ul>
</div>

<p>Usuários na base:  @n_items@</p>

<formtemplate id="search"></formtemplate>
<listtemplate name="items"></listtemplate>
