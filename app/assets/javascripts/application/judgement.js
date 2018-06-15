var judgement = (function(Rx, $) {
    var module = {};

    module.init = function() {

        var switcherId = 'evaluation-tab';
        window.setTimeout(function() {
          openTab(switcherId);
        }, 50);
        initLinks(switcherId);
    }

    function openTab(switcherId) {
      var hash = window.location.hash;
      if (!hash) { return }

      var link = $('#' + switcherId + ' a[href="' + hash + '"]');
      link.click();
    }

    function initLinks(switcherId) {
      $('#' + switcherId + ' a').click(function() {
          var val = $(this).attr('href');
          window.location.hash = val.replace("#", "");
          links = $('.uk-pagination a');
          links.each(function(id) {
            links[id].href = links[id].href.split('#')[0] + val;
          });
      });
    }

    return module;
}(Rx, jQuery));

$(document).ready(judgement.init);
