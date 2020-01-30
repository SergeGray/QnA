$(document).on('turbolinks:load', function() {
  $('.voting').each( function() {
    let opinion = $(this).data('opinion');
    let className = $(this).data('className');
    let id = $(this).data('id');
    let linkName = className + '-' + id + '-link';

    hideCurrent(opinion, linkName);
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

function hideCurrent(opinion, linkName) {
  if (opinion == null) {
    $('.cancel-' + linkName).hide();
  } else if (opinion) {
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
