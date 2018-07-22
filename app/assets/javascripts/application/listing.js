var listing = (function() {
  var module = {};

  module.init = function() {
    $('#membership-tab').on('click', function () {
      UIkit.grid('#inactive_users_grid').init();
      UIkit.grid('#active_users_grid').init();
      UIkit.grid('#archived_users_grid').init();
    });
  };

  return module;
}(Helpers, Rx, jQuery));
$(document).ready(listing.init);
