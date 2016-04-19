$(document).ready(function () {

    if(window.location.href.indexOf("/search") > -1) {
        var query = getUrlParameter("query");
        $("#search-field").val(query);
        updateSuggestions(query);
    }

    var input = document.querySelector('#search-field');

    var inputStream = Rx.Observable.fromEvent(input, "keyup")
        .debounce(100)
        .map(function () {
            return input.value;
        })
        .distinctUntilChanged();

    inputStream.subscribe(inputChange);

    function updateSuggestions(query) {
        if(query.length > 0) {
            $.ajax({
                method: 'GET',
                url: '/search/suggest',
                data: {query: query}
            }).done(function (resp) {
                $('#suggestions').html(resp);
                document.title = "Keresés: " + query;
                window.history.pushState({ "html" : resp.html, "pageTitle" : "Keresés: " + query },"", "/search?query=" + query);
            });
        }
    }

    function inputChange (query) {
        if(window.location.href.indexOf("/search") > -1) {
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

    function getUrlParameter(sParam) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1)),
            sURLVariables = sPageURL.split('&'),
            sParameterName,
            i;

        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('=');

            if (sParameterName[0] === sParam) {
                return sParameterName[1] === undefined ? true : sParameterName[1];
            }
        }
    };
});
