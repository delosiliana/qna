# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  questionsList = $(".questions_list")

  $(document).on 'click', '.edit-question-link', (e) ->
    e.preventDefault();
    $(this).hide();
    question_id = $(this).data('questionId')
    $('form#edit-question-' + question_id).show()

  App.cable.subscriptions.create('QuestionsChannel',{
    connected: ->
      console.log 'Connected'
      @perform 'follow'
      console.log 'follow'
    ,
    received: (data) ->
      questionsList.append data
  })



