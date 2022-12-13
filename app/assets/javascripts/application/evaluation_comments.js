var evaluationComments = (function($) {
  var module = {};
  var selectedInput = null;

  module.init = function() {
    $('.point-input').on('click', onClick);
  }

  function onClick() {
    selectElement(this);
    fetchComments(this);
  }

  function fetchComments(input) {
    const principle = input.getAttribute('data-principle');
    const user = input.getAttribute('data-user');
    const commentUrl = evaluationURL + '/point_detail_comments?principle_id=' + principle + '&user_id=' + user;
    $.ajax({
      url: commentUrl,
      success: loadComments
    });
  }

  function loadComments(data) {
    $('#comment-container').html(data);
    $('#comment-textarea').keypress(function(event){
      if ((event.ctrlKey || event.metaKey) && (event.keyCode == 13 || event.keyCode == 10)) {
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
