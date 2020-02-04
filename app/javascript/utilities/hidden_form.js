$(document).on('turbolinks:load', function() {
  hiddenEditForm('answer');
  hiddenEditForm('question');
  hiddenNewForm('comment', 'question');
  hiddenNewForm('comment', 'answer');

});

function hiddenEditForm(resource) {
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

function hiddenNewForm(resource, parent) {
  $('.' + resource + '-links').on(
    'click',
    '.new-' + resource + '-link',
    function(event) {
      event.preventDefault();
      $(this).hide();
      let parentId = $(this).data(parent + 'Id');
      $('form#new-' + parent + '-' + parentId + '-' + resource)
        .removeClass('hidden');
    }
  );
}
