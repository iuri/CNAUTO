<master>
<property name="context">@context;noquote@</property>
<property name="title">@title;noquote@</property>

<p>
<table border=0>
<tr><th>#news.Title#</th>
     <th>#news.Creation_Date#</th>
     <th>#news.Author#</th>
</tr>
 <multiple name=items>
  <if @items.rownum@ odd>
  <tr class="odd">
  </if>
  <else>
  <tr class="even">
  </else>
  <td><a href="revision?item_id=@items.item_id@&revision_id=@items.revision_id@">@items.publish_title@</a></td>
       <td>@items.creation_date@</td>
       <td>@items.item_creator@</td>
 </tr>
 </multiple>
</table>




<form action=approve-2 method=post enctype=multipart/form-data>
@hidden_vars;noquote@
<input type=hidden name=revision_id value="<multiple name=items>@items.revision_id@ </multiple>">




<p class="formLabel"><label for="archive_date">#news.Archive_Date#</p>
<p class="formWidget">@archive_date_select;noquote@<br />
<input type=checkbox name=permanent_p value=t id="never"> <b><label for="never">#news.never#</label></b> #news.show_it_permanently#</p>


<p>

<input type=submit value="#news.Release#">
</p>
</form>






