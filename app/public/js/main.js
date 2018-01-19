$(document).ready(function(e) {
  $('#qform').submit(function(e) {
    if (!$('#q').val()=='') {
      $.get('/hanzify?' + $('#qform').serialize(), function(data){
        $('#result').html(data);
      });
    }
    else {
      $('#result').html('<span class="elucidation">(output here)</span>');
    }
    e.preventDefault();
  });
});