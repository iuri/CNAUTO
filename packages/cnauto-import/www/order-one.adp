<master>

<property name="title">@title;noquote@</property>
<property name="name">@context;noquote@</property>


<br><br><h1><u>#cnauto-import.CNIMP# @cnimp_number@</u></h1>


<table cellpadding="10px" cellspacing="0" border="1">
  <tr>
    <td width="30%" align="left" valign="top">
      <table cellpadding="0" cellspacing="0">
        <tr>
	  <td width="45%" align="left" valign="top">&nbsp;</td>
	  <td width="10%" align="left" valign="top">&nbsp;&nbsp;&nbsp;</td>
	  <td width="45%" align="left" valign="top">&nbsp;</td>
	</tr>
	<tr>
	  <td width="45%" align="left" valign="top"><b>#cnauto-import.CNIMP_date#</b><br>@cnimp_date@<br><br></td>
	  <td width="10%" align="left" valign="top">&nbsp;</td>
	  <td width="45%" align="left" valign="top"><b>#cnauto-import.Provider#</b><br> @provider@<br><br></td>
	</tr>
	<tr>
	  <td><b>#cnauto-import.Approval_date#</b><br> @approval_date@</td>
	  <td>&nbsp;&nbsp;&nbsp;</td>
	  <td>
	    <b>#cnauto-import.LI_need_p#</b><br> 
	     <if @li_need_p@ eq t> 
	       <input type="checkbox" name="li_need_p" checked>
	     </if>
	     <else>
	       <input type="checkbox" name="li_need_p" checked>
	     </else>
	   </td>
	 </tr>
         <tr>
 	   <td>&nbsp;</td>
	   <td>&nbsp;</td>
	   <td align="right"><a href="order-ae?order_id=@order_id@&step=1&return_url=@return_url@">#cnauto-import.Edit#</a></td>
	 </tr>
	 <tr>
	   <td><hr></td>
	   <td><hr></td>
	   <td><hr></td>	 	 
	 </tr>
	 <tr>
	   <td width="45%" align="left" valign="top"><h1><u>#cnauto-import.Departure#</u></h1></td>
	   <td width="10%" align="left" valign="top">&nbsp;</td>
	   <td width="45%" align="left" valign="top">&nbsp;</td>
 	 </tr>
	 <tr>
	   <td width="45%" align="left" valign="top">
	      <b>#cnauto-import.Payment_date#</b><br> @payment_date@<br><br>
	   </td>
	   <td width="10%" align="left" valign="top">
	   <td width="45%" align="right" valign="top">
	      <b>#cnauto-import.Manufactured_date#</b><br> @manufactured_date@<br><br>
	   </td>
	 </tr>
	 <tr>
	   <td width="45%" align="left" valign="top">
      	      <b>#cnauto-import.Departure_date#</b><br> @departure_date@<br><br>
           </td>
	   <td width="10%" align="left" valign="top">&nbsp;</td>
	   <td width="45%" align="right" valign="top">
	      <b>#cnauto-import.AWB_BL_number#</b><br> @awb_bl_number@<br><br>
	   </td>
	 </tr>
	 <tr>
	   <td width="45%" align="left" valign="top">&nbsp;</td>
	   <td width="10%" align="left" valign="top">&nbsp;</td>
	   <td width="45%" align="right" valign="top">
	     <b>#cnauto-import.Arrival_date#</b> @arrival_date@
	   </td>
	 </tr>
         <tr>
	   <td width="45%" align="left" valign="top">&nbsp;</td>
	   <td width="10%" align="left" valign="top">&nbsp;</td>
	   <td width="45%" align="right"><a href="order-ae?order_id=@order_id@&step=2&return_url=@return_url@">#cnauto-import.Edit#</a></td>
	 </tr>
	 <tr>
	   <td>&nbsp;</td>
	   <td>&nbsp;</td>
	   <td>&nbsp;</td>
	 </tr>
       </table>
    </td>
    <td width="30%" align="right" valign="top">
      <table width="100%" cellpadding="0" cellspacing="0" border="0">
        <tr>
	  <td width="45%" align="left" valign="top"><h1><u>#cnauto-import.DI#</u></h1></td>
 	  <td width="10%" align="left" valign="top">&nbsp;</td>
    	  <td width="45%" align="right" valign="top">
	    <div style="width: 20px; height:20px; background: @di_status;noquote@;">&nbsp;</div>
	  </td>
	</tr>
        <tr>
	  <td width="45%" align="left" valign="top">
	    <b>#cnauto-import.Numerary_date#</b><br> @numerary_date@<br><br>
          </td>
 	  <td width="10%" align="left" valign="top">&nbsp;</td>
    	  <td width="45%" align="right" valign="top">
  	    <b>#cnauto-import.DI_date#</b><br> @di_date@<br><br>
	  </td>
	</tr>
        <tr>
	  <td width="45%" align="left" valign="top">
	    <b>#cnauto-import.NF_date#</b><br> @nf_date@<br><br>
          </td>
 	  <td width="10%" align="left" valign="top">&nbsp;</td>
    	  <td width="45%" align="right" valign="top">
  	    <b>#cnauto-import.Delivery_date#</b><br> @delivery_date@
	  </td>
	</tr>
	<tr>
	  <td width="45%" align="left" valign="top">&nbsp;</td>
 	  <td width="10%" align="left" valign="top">&nbsp;</td>
    	  <td width="45%" align="right" valign="top"><a href="order-ae?order_id=@order_id@&step=3&return_url=@return_url@">#cnauto-import.Edit#</a></td>
	</tr>
	 <tr>
	   <td><hr></td>
	   <td><hr></td>
	   <td><hr></td>	 	 
	 </tr>
        <tr>
	  <td width="45%" align="left" valign="top"><h1><u>#cnauto-import.Modal#</h1></u>@incoterm_pretty@</td>
 	  <td width="10%" align="left" valign="top">&nbsp;</td>
    	  <td width="45%" align="right" valign="top"><h1><u>#cnauto-import.Airport_Seaport#</u></h1> @transport_type@</td>
	</tr>
	<tr>
	  <td width="45%" align="left" valign="top">&nbsp;</td>
 	  <td width="10%" align="left" valign="top">&nbsp;</td>
    	  <td width="45%" align="right" valign="top"><a href="order-ae?order_id=@order_id@&step=4">#cnauto-import.Edit#</a></td>
	</tr>
	 <tr>
	   <td><hr></td>
	   <td><hr></td>
	   <td><hr></td>	 	 
	 </tr>
	 <tr>
  	  <td  width="45%" align="left" valign="top"><h1><u>#cnauto-import.Order#</u></h1></td>
	  <td  width="10%" align="left" valign="top">&nbsp;</td>
    	  <td width="45%" align="right" valign="top">&nbsp;</td>
	</tr>
        <tr>
	  <td width="45%" align="left" valign="top"><b>#cnauto-import.Order_cost#</b><br> @order_cost@<br><br></td>
	  <td  width="10%" align="left" valign="top">&nbsp;</td>		
	  <td width="45%" align="left" valign="top"><b>#cnauto-import.Exchange_rate_type#</b><br> @exchange_rate_type@<br><br></td>
	</tr>
        <tr>
	  <td width="45%" align="left" valign="top"><b>#cnauto-import.LC_number#</b><br> @lc_number@<br><br></td>
	  <td width="10%" align="left" valign="top">&nbsp;</td>
	  <td width="45%" align="left" valign="top"><b>#cnauto-import.Start_date#</b><br> @start_date@<br><br></td>
	</tr>
      </table>
      <table>
        <tr>
          <td><b>#cnauto-import.Notes#</b><br> @notes@</td>
        </tr>
        <tr>
	 <td><div style="float:right;"><a href="order-ae?order_id=@order_id@&step=4&return_url=@return_url@">#cnauto-import.Edit#</a></div></td>
	</tr>
	<tr>
	  <td>&nbsp;</td>
	</tr>
      </table>
    </td>
    <td valign="top" width="36%">  
      <h1><u>#cnauto-import.Notes#</u></h1>
      <a href="@comment_add_url@">#cnauto-import.Add_note#</a>
      <hr>
      @comments_html;noquote@
    </td>
  </tr>
</table>