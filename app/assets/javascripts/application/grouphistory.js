var grouphistory = (function() {
  var module = {};

  module.init = function() {
    var select = document.getElementById('point-history-select');
    if (!select){ return; }
    select.addEventListener('change', function() {
      document.getElementById('point-history-form').submit();
    });
  }

  return module;
}());

$(document).ready(grouphistory.init);
