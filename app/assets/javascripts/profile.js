
var cropper;
$(document).ready(function () {
    if($('#cropper-img').length > 0) {
        cropper = new Cropper(document.getElementById('cropper-img'), {
            aspectRatio: 1/1,
            zoomable: false,
            movable: false,

        });
    }
});

function cropDone() {
    var croppedData = cropper.getCroppedCanvas({
        width: 300,
        height: 300
    }).toDataURL();
    $.ajax({
        type: "POST",
        url: "/settings/upload",
        data: {
            croppedData: croppedData
        }
    }).done(function (data) {
        UIkit.notify({
            message : 'Sikeres feltöltés!',
            status  : 'info',
            timeout : 5000,
            pos     : 'top-center'
        });
    });
}