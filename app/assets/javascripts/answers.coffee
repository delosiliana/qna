# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(document).on 'click', '.edit-answer-link', (e) ->
    e.preventDefault();
    $(this).hide();
    answerId = $(this).data('answerId')
    $('form#edit-answer-' + answerId).show()

  App.cable.subscriptions.create({ channel:'AnswersChannel', question_id: gon.question_id }, {
    connected: ->
      console.log('Connect answer')
      question_id = $('.question').data('id')
      @perform 'follow'
      console.log('Good connect')
    ,

    received: (data) ->
      return if gon.user_id == data.answer.user_id
      $('.answers').append(JST['templates/answer'](data))
  })



