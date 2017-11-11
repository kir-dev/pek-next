var search = (function(Helpers, Rx, $) {
    var page = 1;
    var module = {};

    module.init = function() {
        if($('#suggestions').length > 0) {
            var query = Helpers.getUrlParameter("query");
            $("#search-field").val(query);
            updateSuggestions(query);
        }

        var input = document.querySelector('#search-field');

        if(input != null) {
            var inputStream = Rx.Observable.fromEvent(input, "keyup")
                .debounce(100)
                .map(function () {
                    return input.value;
                })
                .distinctUntilChanged();

            inputStream.subscribe(inputChange);
        }

        $("#show-more").click(showMore);
    }

    function updateSuggestions(query) {
        if(query.length > 0) {
            $('#suggestions').load('/search/suggest', $.param({query: query}), function (resp) {
                document.title = "Keresés: " + query;
                window.history.pushState({ "html" : resp.html, "pageTitle" : "Keresés: " + query },"", "/search?query=" + query);
            });
        }
    }

    function inputChange (query) {
        if($('#suggestions').length > 0) {
            updateSuggestions(query);
        } else {
            $.ajax({
                method: 'GET',
                url: '/search',
                data: {query: query}
            }).done(function (resp) {
                $('#content-container').html($(resp).filter("#content-container").html());

                document.title = "Keresés";
                window.history.pushState({ "html" : resp.html, "pageTitle" : "Keresés"},"", "/search?query=" + query);
                updateSuggestions(query);
                $("#show-more").click(showMore);
            });
        }
    }

    function showMore() {
        var query = Helpers.getUrlParameter("query");

        if(query.length === 0) {
            return;
        }
        $.get('/search/suggest', {query: query, page: page++}, function (resp) {
            $(resp).appendTo($('#suggestions'));
            if(resp.length === 0){
                $('#show-more').addClass( 'uk-hidden' );
                $('#no-more').removeClass( 'uk-hidden' );
            }
        });
    }

    return module;
}(Helpers, Rx, jQuery));

$(document).ready(search.init);
