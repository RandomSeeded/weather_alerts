$(function() {
  $('#subscription-form').submit(function(event) {
    event.preventDefault();
    var data = $("#subscription-form :input").serializeArray();
    var body = {};
    for (var i = 0; i < data.length; i++) {
      var elem = data[i];
      body[elem.name] = elem.value;
    }

    // TODO (nw): remove this once added to the html
    body.threshold = "fair";
    body.withinPeriod = 4;

    $.post('http://localhost:1080/api/subscribe', body, function(res) {
      $('#subscribe-success').fadeIn();
      setTimeout(function() {
        $('#subscribe-success').fadeOut();
      }, 5000);
    });
  });
});
