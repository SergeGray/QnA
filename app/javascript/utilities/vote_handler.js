$(document).on('turbolinks:load', function() {
  $(document).on('ajax:success', function(event) {
    let question = event.detail[0];

    $('.question-score').html(question.score);
  });
});
