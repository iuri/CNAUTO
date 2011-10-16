<master>
<br>
<p style="font-size: 20px;" >Confirma o Envio dessa mensagem para <b>@qtd@ de um total de @qtd_total@</b> emails?</p>
<br><br>

<form action="@__return_url__@" method="post">
  <multiple name="__form_contents__">
    <input type="hidden" name="@__form_contents__.__key__@" value="@__form_contents__.__value__@">
  </multiple>
  <input type="submit" value="Confirmar envio">
</form>
<br>
<br>
<if @qtd@ lt 50>
	<h3>Lista de emails a serem enviados:</h3>
	@lista_de_emails;noquote@

</if>
