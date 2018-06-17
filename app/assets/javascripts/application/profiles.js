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
    $('#share-profile').bind('click', copyToClipboard);
  }

  copyToClipboard = function() {
    var link = $('#share-profile').attr('data-link');
    var aux = document.createElement('input');
    aux.setAttribute('value', link);
    document.body.appendChild(aux);
    aux.select();
    document.execCommand('copy');
    UIkit.notify({
      status: 'success',
      message: 'Profil link sikeresen másolva!',
      timeout: 2000
    });
    document.body.removeChild(aux);
  }

  return module;

}(Helpers, Rx, jQuery));

$(document).ready(profiles.init);
