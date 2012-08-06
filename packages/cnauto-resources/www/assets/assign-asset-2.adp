<master>

<br><br>

<if @owner@ ne "">
  <h2>The asset is already taken to the user: @owner@ <br><br> Do you really want to reassign it?</h2>
  <form name="assign_asset" method="get" action="assign-asset-2">
    <input type="hidden" name="user_id" id="user_id" value=@user_id@>
    <input type="hidden" name="asset_id" id="asset_id" value=@asset_id@>
    <input type="hidden" name="confirm" id="confirm" value=1>
    <input type="submit" name="submit" id="submit" value="Confirm">
    <input type="button" value="Cancel" onclick="javascript:parent.location='@return_url@'" />
  </form>
</if>