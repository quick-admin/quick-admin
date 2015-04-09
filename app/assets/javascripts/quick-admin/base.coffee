#= require jquery-ui
#= require semantic-ui
#= require_tree

$(document).ready ->
  $('#toc.sidebar').first().sidebar 'attach events', '#topbar a.toggle'