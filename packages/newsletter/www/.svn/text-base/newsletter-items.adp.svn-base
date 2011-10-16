<master>
<property name="title">@title@</property>
<div class="options_list">
<ul>
	<if @admin_p@>
		@buttons;noquote@
		<li><a class="button" href="newsletter-image-save?newsletter_id=@newsletter_id@" title="#newsletter.Image_save#" alt="#newsletter.Image_save#">#newsletter.Image_save#</a></li>
		<li><a class="button" href="newsletter-users?newsletter_id=@newsletter_id@" title="#newsletter.Users#" alt="#newsletter.Users#">#newsletter.Users#</a></li>
	</if>
</ul>
</div>
<table class="newsletter_items">
	<tr>
		<td>#newsletter.Date#</td>
		<td>#newsletter.Item#</td>
		<if @admin_p@>
			<td>#newsletter.Send#</td>
			<td>#newsletter.Edit#</td>
			<td>#newsletter.Delete#</td>
			<td>#newsletter.Report#</td>
		</if>
	</tr>
	<multiple name="newsletter_list">
		<tr><td>@newsletter_list.publish_date@ </td><td> <a href="item-view?newsletter_item_id=@newsletter_list.newsletter_item_id@">@newsletter_list.title@</a></td>
			<if @admin_p@>
			<td><a class="button" href="newsletter-newsitems-send?newsletter_item_id=@newsletter_list.newsletter_item_id@&newsletter_id=@newsletter_list.newsletter_id@">Send</a> </td>
			<td><a class="button" href="newsletter-newsitems-edit?newsletter_item_id=@newsletter_list.newsletter_item_id@&newsletter_id=@newsletter_list.newsletter_id@">Edit</a></td>
			<td><a class="button" href="newsletter-newsitems-del?newsletter_item_id=@newsletter_list.newsletter_item_id@&newsletter_id=@newsletter_list.newsletter_id@">Delete</a></td>
			<td>@newsletter_list.num_email_list@</td>
			</if>
		</tr>
	</multiple>
</table>
	<p><a class="button" href="newsletter-email-new?newsletter_id=@newsletter_id@" title="#newsletter.Register_your_email#" alt="#newsletter.Register_your_email#">#newsletter.Register_your_email#</a></p>
