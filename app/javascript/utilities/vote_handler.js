$(document).on('turbolinks:load', function() {
  hideCurrent();
  switchButtons('upvote');
  switchButtons('downvote');
  cancelVote();

  $(document).on('ajax:success', function(event) {
    let question = event.detail[0];

    $('.question-score').html(question.score);
  });
});

function hideCurrent() {
  let opinion = $('.question-voting').data('opinion');
  out: if (opinion == null) {
    $('.cancel-question-link').hide();
  } else if (opinion) {
    $('.upvote-question-link').hide();
  } else {
    $('.downvote-question-link').hide();
  };
};

function switchButtons(button) {
  $('.question-voting')
    .on('click', '.' + button + '-question-link', function(event) {
      let opposite = button == 'upvote' ? 'downvote' : 'upvote';
      event.preventDefault();
      $(this).hide();
      $('.cancel-question-link').show();
      $('.' + opposite + '-question-link').show();
  });
};

function cancelVote() {
  $('.question-voting').on('click', '.cancel-question-link', function(event) {
    event.preventDefault();
    $(this).hide();
    $('.upvote-question-link').show();
    $('.downvote-question-link').show();
  });
};
