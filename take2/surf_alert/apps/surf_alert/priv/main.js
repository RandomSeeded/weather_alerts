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

    $.post('/api/subscribe', body, function(res) {
      $('#subscribe-success').fadeIn();
      setTimeout(function() {
        $('#subscribe-success').fadeOut();
      }, 5000);
    });
  });
});
