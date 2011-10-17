ad_page_contract {


} {
	item_id
}


set image_id [ImageMagick::util::get_image_id -item_id $item_id -name_null 1]
if {![empty_string_p $image_id]} { 
  set publish_image "./image/$image_id"
} else {
  set publish_image ""
}

ah::requires -sources "cropper"

ad_form -name crop_image -export {item_id image_id} -form {
	{x1:text(hidden) {html {id x1}}}
	{y1:text(hidden) {html {id y1}}}
	{width:text(hidden) {html {id width}}}
	{height:text(hidden) {html {id height}}}
} -on_submit {


	set path [cr_fs_path CR_FILES]
	set filename [db_string write_file_content {select :path || content
          					from cr_revisions
	            				where revision_id = :image_id}]

	set tmp_image [ns_mktemp "/tmp/image-XXXXXX"]
	append tmp_image ".jpeg"
	set crop "${width}x${height}+${x1}+${y1}"

	ImageMagick::convert -options "-crop $crop" $filename $tmp_image


	set image_id [ImageMagick::util::get_image_id -item_id $item_id -name "max-priority-image"]
	if {$image_id != ""} { 
		set image_item_id [content::revision::item_id -revision_id $image_id]
		ImageMagick::util::revise_image -file $tmp_image -item_id $image_item_id -name "max-priority-image"
	} else {
		ImageMagick::util::create_image_item -file $tmp_image -parent_id $item_id -name "max-priority-image"
	}
        util_memoize_flush_regexp "news*"

	file delete $tmp_image

} -after_submit {
	ad_returnredirect "item?item_id=$item_id"
}
