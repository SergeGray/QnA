$(document).on('turbolinks:load', function() {
  $('.voting').each( function() {
    let voteValue = $(this).data('voteValue');
    let className = $(this).data('className');
    let id = $(this).data('id');
    let linkName = className + '-' + id + '-link';

    hideCurrent(voteValue, linkName);
    switchButtons($(this), 'upvote', linkName);
    switchButtons($(this), 'downvote', linkName);
    cancelVote($(this), linkName);
  });

  $(document).on('ajax:success', function(event) {
    let question = event.detail[0];

    $('.' + question.class_name + '-' + question.id + '-score')
      .html(question.score);
  });
});

function hideCurrent(voteValue, linkName) {
  if (voteValue === 0) {
    $('.cancel-' + linkName).hide();
  } else if (voteValue > 0) {
    $('.upvote-' + linkName).hide();
  } else {
    $('.downvote-' + linkName).hide();
  };
};

function switchButtons(object, button, linkName) {
  object.on('click', '.' + button + '-' + linkName, function(event) {
    let opposite = button == 'upvote' ? 'downvote' : 'upvote';

    event.preventDefault();
    $(this).hide();
    $('.cancel-' + linkName).show();
    $('.' + opposite + '-' + linkName).show();
  });
};

function cancelVote(object, linkName) {
  object.on('click', '.cancel-' + linkName, function(event) {
    event.preventDefault();
    $(this).hide();
    $('.upvote-' + linkName).show();
    $('.downvote-' + linkName).show();
  });
};
