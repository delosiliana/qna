$ ->
  $('.vote').bind 'ajax:success', (e) ->
    $(this).parent().find('p.total_votes').html(e.detail[0])
    $('.error_vote').html("")
  $('.vote').bind 'ajax:error', (e) ->
    $('.error_vote').html(e.detail[0])


