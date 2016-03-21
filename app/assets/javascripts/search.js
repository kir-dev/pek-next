$(document).ready(function () {

	var input = document.querySelector('#search-field');

	var inputStream = Rx.Observable.fromEvent(input, "keyup")
		.debounce(100)
		.map(function () {
			return input.value;
		})
		.distinctUntilChanged();

	inputStream.subscribe(search);

	function search (query) {
		$.ajax({
			method: 'GET',
			url: '/search/suggest',
			data: {query: query}
		}).done(function (resp) {
			$('#suggestions').html(resp);
		});
	}
});
