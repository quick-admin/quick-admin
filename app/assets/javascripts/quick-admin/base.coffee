#= require jquery-ui
#= require semantic-ui
#= require nprogress
#= require nprogress-turbolinks
#= require_tree

$(document).ready ->
  $('#toc.sidebar').first().sidebar 'attach events', '#topbar a.toggle'