var Helpers = (function () {
  var helpers = {};

  helpers.getUrlParameter = function(sParam) {
    var sPageURL = decodeURIComponent(window.location.search.substring(1)).replace(/\+/g, ' '),
      sURLVariables = sPageURL.split('&'),
      sParameterName,
      i;

    for (i = 0; i < sURLVariables.length; i++) {
      sParameterName = sURLVariables[i].split('=');

      if (sParameterName[0] === sParam) {
        return sParameterName[1] === undefined ? true : sParameterName[1];
      }
    }
  };

  helpers.initSwitcher = function(switcherId) {
    window.setTimeout(function() {
      openTab(switcherId);
    }, 50);
    initLinks(switcherId);
  }

  function openTab(switcherId) {
    var hash = window.location.hash;
    if (!hash) { return; }

    var link = $('#' + switcherId + ' a[href="' + hash + '"]');
    link.click();
  }

  function initLinks(switcherId) {
    $('#' + switcherId + ' a').click(function() {
      var val = $(this).attr('href');
      window.location.hash = val.replace('#', '');
      $('.uk-pagination a').each(function(id) {
        this.href = this.href.split('#')[0] + val;
      });
    });
  }

  return helpers;
}());
