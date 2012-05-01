<master>

<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<br>
<h1>@title;noquote@</h1>

<div style="float:right;">
<form action="index" name="search" method="post">
<input type="text" name="keyword" id="keyword">
<input type="submit" name="submit" id="submit" value="#cnauto-import.Search#">
</form>
</div>

<listtemplate name="orders"></listtemplate>