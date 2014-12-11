#= require bootstrap-datetimepicker
#= require locales/bootstrap-datetimepicker.zh-CN.js

$(document).ready ->
  $('.kpb-datetimepicker, .date_filter').datetimepicker
    format: 'yyyy-mm-dd',
    language:  'zh-CN',
    weekStart: 1,
    todayBtn:  1,
    autoclose: 1,
    todayHighlight: 1,
    startView: 2,
    minView: 2,
    forceParse: 0