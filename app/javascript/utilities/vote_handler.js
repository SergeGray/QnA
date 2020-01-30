$(document).on('turbolinks:load', function() {
  hideCurrent();
  switchButtons('upvote');
  switchButtons('downvote');
  cancelVote();

  $(document).on('ajax:success', function(event) {
    let question = event.detail[0];

    $('.resource-score').html(question.score);
  });
});

function hideCurrent() {
  let opinion = $('.resource-voting').data('opinion');
  out: if (opinion == null) {
    $('.cancel-resource-link').hide();
  } else if (opinion) {
    $('.upvote-resource-link').hide();
  } else {
    $('.downvote-resource-link').hide();
  };
};

function switchButtons(button) {
  $('.resource-voting')
    .on('click', '.' + button + '-resource-link', function(event) {
      let opposite = button == 'upvote' ? 'downvote' : 'upvote';
      event.preventDefault();
      $(this).hide();
      $('.cancel-resource-link').show();
      $('.' + opposite + '-resource-link').show();
  });
};

function cancelVote() {
  $('.resource-voting').on('click', '.cancel-resource-link', function(event) {
    event.preventDefault();
    $(this).hide();
    $('.upvote-resource-link').show();
    $('.downvote-resource-link').show();
  });
};
