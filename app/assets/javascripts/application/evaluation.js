var evaluation = (function(Rx, $) {
    var module = {};
    var cropper;

    module.init = function() {

        var input = document.querySelectorAll('.point-input');

        if(input != null) {
            var inputStream = Rx.Observable.fromEvent(input, "change")
                .map(event => event.target);

            inputStream.subscribe(inputChange);
        }
    }

    function inputChange (input) {
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
        });
    }

    return module;
}(Rx, jQuery));

$(document).ready(evaluation.init);
