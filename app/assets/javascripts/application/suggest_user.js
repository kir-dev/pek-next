var counter = 0;
function suggestions () {
    return document.getElementById('user_suggestions');
};

window.onload = function () {
    subscribeToInput();
};

function subscribeToInput() {
    var input = document.getElementById("group_leader_name");
    if (input != null) {
        var inputStream = Rx.Observable.fromEvent(input, "keyup")
            .debounce(100)
            .map(function () {
                return input.value;
            })
            .distinctUntilChanged();

        inputStream.subscribe(suggestUser);
    }
}

function suggestUser() {
    fetchUsers(true);
}

function fetchUsers(deletePrevious) {
    var leaderName = document.getElementsByName('group_leader_name')[0].value;
    var page = counter;
    var url = "/search/suggest_leader?query=" + leaderName + "&page=" + page;

    fetch(url).then(function (response) {
        return response.text();
    }).then(function (result) {
        addResultToSuggestions(result, deletePrevious);
    }).catch(function (err) {
        console.warn('Something went wrong.', err);
    });
}

function addResultToSuggestions(result, removePrevious) {
    if (removePrevious) {
        suggestions().innerHTML = '';
    }
    suggestions().insertAdjacentHTML('beforeend', result);
}

function selectUser(user_id, user_name) {
    event.stopPropagation();
    document.getElementById('selected_user_id').value = user_id;
    document.getElementById('group_leader_name').value = user_name;
    suggestions().innerHTML = 'Körvezető kiválasztva!';
}

function showMoreUser() {
    counter+=1;
    fetchUsers(false);
}
