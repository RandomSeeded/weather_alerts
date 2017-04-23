$(function() {
  $('#subscription-form').submit(function(event) {
    event.preventDefault();
    var data = $("#subscription-form :input").serializeArray();
    var body = {};
    for (var i = 0; i < data.length; i++) {
      var elem = data[i];
      body[elem.name] = elem.value;
    }

    $.post('http://localhost:1080/api/email-submit', body, function(res) {
      $('#subscribe-success').fadeIn();
      setTimeout(function() {
        $('#subscribe-success').fadeOut();
      }, 5000);
    });
  });
});
