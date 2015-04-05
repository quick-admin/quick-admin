#= require jquery-ui
#= require semantic-ui

$(document).ready ->
  $('#toc.sidebar').first().sidebar 'attach events', '#topbar a.toggle'