var evaluationSync = (function(Rx, $) {
  var module = {};

  module.init = function() {
    var input = document.querySelectorAll('.point-input');
    if (input != null) {
      var inputStream = Rx.Observable.fromEvent(input, 'change')
        .map(function(event) { return event.target; });

      inputStream.subscribe(inputChange);
    }
  }

  function inputChange(input) {
    $('#save-icon').fadeIn();
    var value = input.value;
    var principle = input.getAttribute('data-principle');
    var user = input.getAttribute('data-user');

    evaluationTable.overwritePrincipleSumText(principle);

    $.ajax({
      method: 'POST',
      url: updateURL,
      data: {
        principle_id: principle,
        user_id: user,
        point: value
      }
    }).done(function (resp) {
      evaluationTable.refreshSumOfPrinciple(input);
      $('#save-icon').fadeOut();
    }).error(function () {
      UIkit.notify({
        message: 'Hiba történt a mentés során! Ellenőrizd az internetkapcsolatod!',
        timeout: 10000,
        status: 'danger'
      });
      $('#save-icon').fadeOut();
    });
  }

  return module;
}(Rx, jQuery));

$(document).ready(evaluationSync.init);
