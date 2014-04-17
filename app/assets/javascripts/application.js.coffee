# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# NOTE: jquery-fileupload/basic and jquery-fileupload/vendor/tmpl are both included in order to allow
# the s3_direct_upload file to function properly. Deleting either file will kill image uploading.
#
# WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
# GO AFTER THE REQUIRES BELOW.
#
#= require jquery
#= require jquery_ujs
#= require jquery.ui.slider
#= require bootstrap-datepicker/core
#= require s3_direct_upload
#= require_tree .
#=