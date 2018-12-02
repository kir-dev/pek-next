var evaluation = (function(Rx, $) {
  var module = {};

  module.init = function() {
    var input = document.querySelectorAll('.point-input');
    if (input != null) {
      var inputStream = Rx.Observable.fromEvent(input, 'change')
        .map(function(event) { return event.target; });

      inputStream.subscribe(inputChange);
    }
    $('.hide-button').on('click', hideRow);
  }

  function hideRow() {
    const userId = this.getAttribute('data-id');
    const row = $('tr*[data-id=' + userId + ']');
    const listItem = $('.name-list-item*[data-id=' + userId + ']');
    const name = listItem.text();
    const hiddenUsersList = $('#hidden-users-list');
    row.addClass('uk-hidden');
    listItem.addClass('uk-hidden');
    hiddenUsersList.append('<li class="hidden-user" data-id="' + userId + '"><a href="#" onclick="evaluation.showRow(' + userId + ')" title="mutatás" uk-tooltip>' + name + '<i class="uk-icon-eye"></i></a></li>');
  }

  module.showRow = function(userId) {
    const button = $('.hidden-user*[data-id=' + userId + ']');
    const row = $('tr*[data-id=' + userId + ']');
    const listItem = $('.name-list-item*[data-id=' + userId + ']');
    button.remove();
    row.removeClass('uk-hidden');
    listItem.removeClass('uk-hidden');
  }

  function inputChange(input) {
    $('#save-icon').fadeIn();
    var value = input.value;
    var principle = input.getAttribute('data-principle');
    var user = input.getAttribute('data-user');

    $.ajax({
      method: 'POST',
      url: updateURL,
      data: {
        principle_id: principle,
        user_id: user,
        point: value
      }
    }).done(function (resp) {
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

$(document).ready(evaluation.init);
