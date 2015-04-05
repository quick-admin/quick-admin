item = $('#<%=j dom_id(resource) %>')

item.effect 'highlight', {}, 100, ->
  $(this).fadeOut 'fast', -> $(this).remove()