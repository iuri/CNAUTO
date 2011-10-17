<master>

<form name="form-order" method="post">
<div class="table_order">
	<input type="hidden" value="" id="order" name="order">
	<div id="debugArea">&nbsp;</div>
		<table id="table-2" cellspacing="0" cellpadding="2">
			<multiple name="news_items">
			<tr id="@news_items.news_id@" class="<if @news_items.rownum@ lt 4>max_priority</if><else><if @news_items.rownum@ odd>odd</if><else>even</else></else>">
				<td>@news_items.rownum@</td>
				<td>@news_items.publish_title@</td>
				<td>@news_items.publish_date_ansi@</td>
			</tr>
			</multiple>

		</table>
</div>

<input type="submit" value="#news.Order#">
</form>

<script type="text/javascript" language="javascript">

$(document).ready(function() {

	// Initialise the first table (as before)
	$("#table-1").tableDnD();

	// Make a nice striped effect on the table
	$("#table-2 tr:even').addClass('alt')");

	// Initialise the second table specifying a dragClass and an onDrop function that will display an alert
	$("#table-2").tableDnD({
	    onDragClass: "myDragClass",
	    onDrop: function(table, row) {
            var rows = table.tBodies[0].rows;
			var debugStr = ""
            for (var i=0; i<rows.length; i++) {
                debugStr += rows[i].id+" ";
            }
			document.getElementById('order').value = debugStr;
	    },
		onDragStart: function(table, row) {
			$("#debugArea").html("Started dragging row "+row.id);
		}
	});
});

</script>



