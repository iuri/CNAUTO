



<div id="tv">
  <h1>TV MDA </h1>

  <div id="box-tv"> 
    <if @videos_p@>   
    <table width="100%">
      <tr><td align="center" valign="top">
        <p><a href="@video.url@/videos-view?video_id=@video.video_id@">@video.video_name@</a></p>

	   <a href="@video.url@/videos-view?video_id=@video.video_id@"><img border="0" src="@video.url@@video.video_id@.jpg" width="@width@"></a>

     
      </td></tr></table>
    </if>
    <p><a href="@videos_url@">#theme-plano-safra.other_videos#</a></p>
    <if @admin_p@>
      <p><a href="@videos_url@videos-new">#videos.New#</a></p>
    </if>
 
  </div>
</div>
