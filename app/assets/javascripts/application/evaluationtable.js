var evaluationTable = (function($) {
  var module = {};
  var hiddenUsersButton = null,
      hiddenUsersList = null;

  module.init = function() {
    const table = $('#points-table');
    if (!table) { return; }
    $('.hide-button').on('click', hideRow);
    hiddenUsersList = $('#hidden-users-list');
    hiddenUsersButton = $('#hidden-users-button');
  }

  module.showRow = function(userId) {
    const button = $('.hidden-user*[data-id=' + userId + ']');
    button.remove();
    changeRowVisibility(userId, true);
    updateHiddenUserButtonState();
  }

  function hideRow() {
    const userId = this.getAttribute('data-id');
    const name = $('.name-list-item*[data-id=' + userId + ']').text();
    hiddenUsersList.append('<li class="hidden-user" data-id="' + userId + '"><a href="#" onclick="evaluationTable.showRow(' + userId + ')" title="mutatás" uk-tooltip>' + name + '<i class="uk-icon-eye"></i></a></li>');
    changeRowVisibility(userId, false);
    updateHiddenUserButtonState();
  }

  function changeRowVisibility(userId, visible) {
    const row = $('tr*[data-id=' + userId + ']');
    const listItem = $('.name-list-item*[data-id=' + userId + ']');
    if (visible) {
      row.removeClass('uk-hidden');
      listItem.removeClass('uk-hidden');
    } else {
      row.addClass('uk-hidden');
      listItem.addClass('uk-hidden');
    }
  }

  function updateHiddenUserButtonState() {
    if (hiddenUsersList.children().length == 0) {
      hiddenUsersButton.removeClass('uk-button-danger');
    } else {
      hiddenUsersButton.addClass('uk-button-danger');
    }
  }

  return module;
}(jQuery));

$(document).ready(evaluationTable.init);
