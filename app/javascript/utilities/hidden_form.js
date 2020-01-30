$(document).on('turbolinks:load', function() {
  hiddenForm('answer');
  hiddenForm('question');
});

function hiddenForm(resource) {
  $('.' + resource + 's').on(
    'click',
    '.edit-' + resource + '-link',
    function(event) {
      event.preventDefault();
      $(this).hide();
      let resourceId = $(this).data(resource + 'Id');
      $('form#edit-' + resource + '-' + resourceId).removeClass('hidden');
    }
  );
}
