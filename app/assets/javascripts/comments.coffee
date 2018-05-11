$ ->
  $(document).on 'click', '.add-comment-link', (e) ->
    e.preventDefault();
    $(this).hide();
    resource_id = $(this).data('resourceId')
    resource_type = $(this).data('resourceType');
    $('form#new_comment_' + resource_type + '_' + resource_id).show()

  $(document).on 'click', '.edit-comment-link', (e) ->
    e.preventDefault();
    $(this).hide();
    comment_id = $(this).data('commentId')
    $('form#edit_comment_' + comment_id).show()

  App.cable.subscriptions.create({ channel:'CommentsChannel', question_id: gon.question_id }, {
    connected: ->
      console.log('Connect comments')
      question_id = $('.question').data('id')
      @perform 'follow'
      console.log('Good connect comments')
    ,

    received: (data) ->
      commentable_type = $.parseJSON(data['comment']).commentable_type.toLowerCase()
      commentable_id = $.parseJSON(data['comment']).commentable_id
      comments = '.' + commentable_type + '_' + commentable_id + '_comments'
      $(comments).append(JST["templates/comment"](comment: $.parseJSON(data['comment'])))
    })

