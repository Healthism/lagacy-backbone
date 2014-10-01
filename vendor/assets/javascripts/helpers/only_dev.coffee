run_callback = (callback) -> callback()
run_nothing  = -> null
window.in_dev = if $("meta[property='js:debug']").attr('content') then run_callback else run_nothing