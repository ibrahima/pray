$('.time-btn').click (event) ->
  $el = $(event.target)
  $('#eta').val($el.data().time)
