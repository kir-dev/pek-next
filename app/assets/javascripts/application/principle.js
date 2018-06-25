var principle = (function(Rx, $) {
  var module = {};

  module.init = function() {
    $('.principle').click(function() {
      principleModal($(this));
    });
  }

  function principleModal(principle) {
    var sumPoint = 0, table = '';

    $('.point-input[data-principle="' + principle.data('id') + '"]').each(function(){
      var value = $(this).val();
      if (value == 0) { return; }

      var userName = $(this).data('user-name');
      table += '<tr><td>' + userName + '</td><td>' + value + '</td></tr>';
      sumPoint += parseInt(value);
    });

    UIkit.modal.alert('<h2>' + principle.text() + '</h2><p>' + principle.data('description') + '</p><table class="uk-table uk-table-striped">' + table + '<tr><td><strong>Összeg</strong></td><td><strong>' + sumPoint + '</strong></td></tr></table>');
  }

  return module;
}(Rx, jQuery));

$(document).ready(principle.init);
