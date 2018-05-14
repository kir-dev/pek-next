var registration = (function() {
  var module = {};
  var urlDescription = null;
  var urlInput = null;

  module.init = function() {
    urlDescription = document.getElementById('url-description');
    urlInput = document.getElementById('url-input');
    if (urlInput)
    urlInput.oninput = update;
  }

  function update() {
    urlDescription.innerHTML = 'Ezen lesz elérhető a profilod a \
    \'pek.sch.bme.hu/profiles/' + urlInput.value + '\' alatt.'
  }

  return module;
}());

$(document).ready(registration.init);
