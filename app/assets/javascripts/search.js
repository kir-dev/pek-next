$(document).ready(function () {

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
                $('#content-main').html($(resp).find("#content-main").html());

                document.title = "Keresés";
                window.history.pushState({ "html" : resp.html, "pageTitle" : "Keresés"},"", "/search?query=" + query);
                updateSuggestions(query);
            });
        }
    }
});

var page = 1;
function showMore() {
    var query = Helpers.getUrlParameter("query");

    if(query.length > 0) {
        $.get('/search/suggest', {query: query, page: page++}, function (resp) {
            $(resp).appendTo($('#suggestions'));
            if(resp.length === 0){
                $('#show-more').hide();
                $('#no-more').show();
            }
        });

    }

}
