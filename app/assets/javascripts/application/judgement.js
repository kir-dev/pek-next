var judgement = (function(Helpers) {
  var module = {};

  module.init = function() {
    Helpers.initSwitcher('evaluation-tab');
  }

  return module;
}(Helpers));

$(document).ready(judgement.init);
