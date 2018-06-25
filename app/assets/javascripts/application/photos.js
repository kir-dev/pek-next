var settings = (function() {
  var module = {};
  var cropper;

  module.init = function() {
    if($('#cropper-img').length > 0) {
      cropper = new Cropper(document.getElementById('cropper-img'), {
        aspectRatio: 1/1,
        zoomable: false,
        movable: false,
      });
    }

    $("#crop-finish-button").click(cropDone)
  }

  function cropDone() {
    var croppedData = cropper.getCroppedCanvas({
      width: 300,
      height: 300
    }).toDataURL();
    $.ajax({
      type: "PUT",
      url: "/photos/me",
      data: {
        croppedData: croppedData
      }
    }).done(function (data) {
      if(data.status == 'success') {
        window.location.replace('/');
      }
    });
  }

  return module;
}());

$(document).ready(settings.init);
