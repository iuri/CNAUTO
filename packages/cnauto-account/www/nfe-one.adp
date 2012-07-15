<master>

<property name="title">@page_title;noquote@</property>
<property name="context">{@page_title;noquote@}</property>

<br><br><h1>@page_title;noquote@</h1>


<form name="claim_ae" action="claim-ae" method="post">
<input type="hidden" id="nfe_id" name="nfe_id" value="@nfe_id@">
 
<table width="100%">
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>
      <a href"@download_url@"><img src="/resources/cnauto-account/images/download.png" alt="#cnauto-account.Download_it#"></a>
      <a href"@email_url@"><img src="/resources/cnauto-account/images/email.png" alt="#cnauto-account.Email_it#"></a>
      <a href "#" onclick="javascript:parent.location='@return_url@'"> <img src="/resources/cnauto-account/images/back.png" alt="#cnauto-account.Return_previous_page#"> </a>
    </td>
  </tr>
  <tr>
    <td><label>#cnauto-account.Key#</label></td>
    <td>
      <input type="text" readonly="readonly" id="nfe.key" name="nfe.key" value="@nfe.key@" size="40"/>
    </td>
    <td><label>#cnauto-account.Protocol#</label></td>
    <td>
      <input type="text" readonly="readonly" id="nfe.prot" name="nfe.prot" value="@nfe.prot@"/>
    </td>
    <td><label>#cnauto-account.Status#</label></td>
    <td>
      <if @nfe.status@ eq 100>
        <img src="/resources/cnauto-account/images/authorized.png">
      </if>
      <if @nfe.status@ eq 101>
        <img src="/resources/cnauto-account/images/canceled.png">
      </if>
    </td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td><label>#cnauto-account.Number#</label></td>
    <td>
      <input type="text" readonly="readonly" id="nfe.number" name="nfe.number" value="@nfe.number@"/>
    </td>
    <td><label>#cnauto-account.Serie#</label></td>
    <td>
      <input type="text" size="5" readonly="readonly" id="nfe.serie" name="nfe.serie" value="@nfe.serie@"/>
    </td>
    <td><label>#cnauto-account.Date#</label></td>
    <td>
      <input type="text" readonly="readonly" id="date" name="date" value="@nfe.date@"/>
    </td>
    <td><label>#cnauto-account.Total#</label></td>
    <td>
      <input type="text" readonly="readonly" id="nfe.total" name="nfe.total" value="@nfe.total@"/>
    </td>
  <tr>
    <td>#cnauto-account.Remitter#</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td><label>#cnauto-account.CNPJ#</label></td>
    <td>
      <input type="text" readonly="readonly" id="nfe.remitter_cnpj" name="nfe.remitter_cnpj" value="@nfe.remitter_cnpj@"/>
    </td>
    <td><label>#cnauto-account.Name#</label></td>
    <td>
      <input type="text" size="40" readonly="readonly" id="nfe.remitter_name" name="nfe.remitter_name" value="@nfe.remitter_name@"/></div>
    </td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>#cnauto-account.Remittee#</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td><label>#cnauto-account.CNPJ#</label></td>
    <td>
      <input type="text" readonly="readonly" id="nfe.remittee_cnpj" name="nfe.remittee_cnpj" value="@nfe.remittee_cnpj@"/>
    </td>
    <td><label>#cnauto-account.Name#</label></td>
    <td>
      <input type="text"  size="40" readonly="readonly" id="nfe.remittee_name" name="nfe.remittee_name" value="@nfe.remittee_name@"/></div>
    </td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>

  </tr>
</table>
</form>
