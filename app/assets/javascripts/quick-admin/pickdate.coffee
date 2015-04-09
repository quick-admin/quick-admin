#= require pickadate/picker
#= require pickadate/picker.date
#= require pickadate/picker.time
#= require pickadate/translations/zh_CN

$(document).ready ->
  $('input.date_filter').pickadate
    format: 'yyyy/m/d'
    formatSubmit: 'yyyy/mm/dd'
    hiddenName: true