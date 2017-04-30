$(function() {
  $('#subscription-form').submit(function(event) {
    event.preventDefault();
    var data = $("#subscription-form :input").serializeArray();
    var body = {};
    for (var i = 0; i < data.length; i++) {
      var elem = data[i];
      body[elem.name] = elem.value;
    }
    body.withinPeriod = body.withinPeriod.replace(/days|day/, '').trim();

    var SUBSCRIBE_URL = window.location.href + 'api/subscribe';

    $.post(SUBSCRIBE_URL, body, function(res) {
      $('#subscribe-success').fadeIn();
      setTimeout(function() {
        $('#subscribe-success').fadeOut();
      }, 5000);
    });
  });
});
