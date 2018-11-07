var grouphistory = (function() {
  var module = {};

  module.init = function() {
    document.getElementById('point-history-select').addEventListener('change', function() {
      document.getElementById('point-history-form').submit();
    });
  }

  return module;
}());

$(document).ready(grouphistory.init);
