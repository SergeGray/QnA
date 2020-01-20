$(document).on('turbolinks:load', function() {
  preventDeleteFollow('answer');
});

function preventDeleteFollow(resource) {
  $('.' + resource + 's').on(
    'click',
    '.delete-' + resource + '-link',
    function(e) {
      e.preventDefault();
    }
  );
}
