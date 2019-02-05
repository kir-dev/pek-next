var evaluationTable = (function($) {
  var module = {};
  var hiddenUsersButton = null,
      hiddenUsersList = null;

  module.init = function() {
    if (typeof initEvaluationTable === 'undefined') { return; }
    const table = $('#points-table');
    $('.hide-button').on('click', hideRow);
    hiddenUsersList = $('#hidden-users-list');
    hiddenUsersButton = $('#hidden-users-button');
    table.arrowTable();
    hideUsers();
  }

  module.showRow = function(userId) {
    const button = $('.hidden-user*[data-id=' + userId + ']');
    button.remove();
    changeRowVisibility(userId, true);
    removeFromHiddenList(userId);
    updateHiddenUserButtonState();
  }

  function hideRow() {
    const userId = this.getAttribute('data-id');
    hideRowById(userId);
  }

  function hideRowById(userId) {
    const name = $('.name-list-item*[data-id=' + userId + ']').text();
    hiddenUsersList.append('<li class="hidden-user" data-id="' + userId + '"><a href="#" onclick="evaluationTable.showRow(' + userId + ')" title="mutatás" uk-tooltip>' + name + '<i class="uk-icon-eye"></i></a></li>');
    changeRowVisibility(userId, false);
    addToHiddenList(userId);
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

  function hideUsers() {
    usersList = getHiddenListFromStorage();
    localStorage.removeItem('hiddenUsers');
    for (var i=0, len=usersList.length; i<len; i++) {
      hideRowById(usersList[i]);
    }
  }

  function removeFromHiddenList(userId) {
    const newList = getHiddenListFromStorage();
    const index = newList.indexOf(userId.toString());
    if (index<0) { return; }
    newList.splice(index, 1);
    saveHiddenListToStorage(newList);
  }

  function addToHiddenList(userId) {
    const newList = getHiddenListFromStorage();
    newList.push(userId);
    saveHiddenListToStorage(newList);
  }

  function getHiddenListFromStorage() {
    const list = localStorage.getItem('hiddenUsers');
    if (!list) { return []; }
    return JSON.parse(list);
  }

  function saveHiddenListToStorage(list) {
    localStorage.setItem('hiddenUsers', JSON.stringify(list));
  }

  module.refreshSumOfPrinciple = function(input) {
    const principleId = input.getAttribute('data-principle');
    const total = calcSum(principleId);

    module.overwritePrincipleSumText(principleId, total);
  }

  module.overwritePrincipleSumText = function(principleId, text){
    text = typeof text !== 'undefined' ? text : '---';
    $('#sum-of-principle-' + principleId).text(text);
  }

  function calcSum(principleId) {
    const principleArray = $('*[data-principle="' + principleId + '"]').toArray();

    const initialValue = 0;
    const reducer = function(accumulator, currentValue) { return accumulator + Number(currentValue.value); };

    return principleArray.reduce(reducer, initialValue);
  }

  return module;
}(jQuery));

$(document).ready(evaluationTable.init);
