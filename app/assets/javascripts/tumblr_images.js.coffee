$('a.deny-image').bind('ajax:before', ->
  $(@).text('Removing..');
  $(@).bind('click', false);
)

$('a.deny-image').bind('ajax:success', ->
  $(@).closest('li').effect(
    "highlight", {}, 3000, 
    ->
      @.remove()
      fixThumbnails()
      $('.main_content').prepend('<div class="alert alert-success">
        <button type="button" class="close" data-dismiss="alert">&times;</button>
        Image has been denied for publishing
      </div>')
  )
)