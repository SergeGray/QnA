$(document).on('turbolinks:load', function() {
  hideCurrent();
  switchButtons('upvote');
  switchButtons('downvote');

  $(document).on('ajax:success', function(event) {
    let question = event.detail[0];

    $('.question-score').html(question.score);
  });
});

function hideCurrent() {
  let opinion = $('.question-voting').data('opinion');
  out: if (opinion == null) {
    break out;
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
    $('.' + opposite + '-question-link').show();
  });
};
