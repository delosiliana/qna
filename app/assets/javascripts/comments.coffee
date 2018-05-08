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

