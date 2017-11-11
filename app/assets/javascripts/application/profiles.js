var profiles = (function(Helpers, Rx, $) {
  var module = {};

  module.init = function() {
    $(".privacy-setting").bind('change', function() {
      $.ajax({
        url: '/privacies/update',
        type: 'POST',
        data: {
          "user": this.getAttribute('user'),
          "visible": this.checked,
          "attribute": this.value
        }
      });
    });
  }

  return module;

}(Helpers, Rx, jQuery));

$(document).ready(profiles.init);
