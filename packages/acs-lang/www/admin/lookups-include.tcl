# Include takes arguments full_key and message_key_list

set full_key_pattern "${package_key}.([join $message_key_list "|"])"

set message_key_context ""
if { [catch {set message_key_context [exec find [acs_root_dir] -type f -regex ".*\\.\\(info\\|adp\\|sql\\|tcl\\)" | xargs egrep "${full_key_pattern}"]} error] } {
    global errorInfo
    regexp "^(.*)child process exited abnormally" $errorInfo match message_key_context
    set message_key_context [ad_quotehtml $message_key_context]
    regsub -all "${full_key_pattern}" $message_key_context {<b>\0</b>} message_key_context
}
