
var cropper;
$(document).ready(function () {
	if($('#cropper-img').length > 0) {
		cropper = new Cropper(document.getElementById('cropper-img'), {
			aspectRatio: 1/1
		});
	}
});

function cropDone() {
	console.log(cropper.getCroppedCanvas());
}