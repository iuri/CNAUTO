<master>
<property name="context">@context_bar;noquote@</property>
<property name="title">#cnauto-import.Confirm_renavam_delete#</property>

<form method="post" action="renavam-delete">	
  <p>#cnauto-resources.Are_you_sure_you_want_to_delete#?</p> 
  <multiple name="renavam">
    @renavam.fabricant@ @renavam.lcvm@ @renavam.model@ @renavam.version@ @renavam.code@<br>
  </multiple>

<div>
  @hidden_vars;noquote@
  <input type="hidden" name="action" value="delete">
  <input type=submit name=submit.x value=#acs-kernel.common_Yes#>
  <input type=submit name=cancel.x value=#acs-kernel.common_No#>
</div>
</form>

