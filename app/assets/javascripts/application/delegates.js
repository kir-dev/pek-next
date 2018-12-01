var delegates = (function($) {
  var module = {};

  module.init = function() {
    $('.update-delegates').on('click', function() {
      const groupId = this.getAttribute('data-group-id');
      $('#group-id').val(groupId);
      const count = this.getAttribute('data-count');
      $('#delegate-count').val(count);
    })
  }

  return module;
}(jQuery));

$(document).ready(delegates.init);
