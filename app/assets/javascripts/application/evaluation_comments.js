var evaluationComments = (function($) {
  var module = {};
  var selectedInput = null;

  module.init = function() {
    $('.point-input').on('dblclick', onDoubleClick);
  }

  function onDoubleClick() {
    selectElement(this);
    fetchComments(this);
  }

  function fetchComments(input) {
    const currentUrl = window.location.href;
    const principle = input.getAttribute('data-principle');
    const user = input.getAttribute('data-user');
    const commentUrl = currentUrl.substring(0, currentUrl.lastIndexOf("/") + 1) + 'point_detail_comments?principle_id=' + principle + '&user_id=' + user;
    $.ajax({
      url: commentUrl,
      success: loadComments
    });
  }

  function loadComments(data) {
    $('#comment-container').html(data);
    $('#comment-textarea').keypress(function(event){
      if(event.ctrlKey && event.which == 13){
           $(this).closest('form').submit();
       }
    });
  }

  function selectElement(input) {
    if (selectedInput) {
      selectedInput.previousElementSibling.classList.add('uk-hidden');
    }
    selectedInput = input;
    input.previousElementSibling.classList.remove('uk-hidden');
  }

  return module;
}(jQuery));

$(document).ready(evaluationComments.init);
