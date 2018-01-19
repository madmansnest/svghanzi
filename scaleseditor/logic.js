$(document).ready(function() {
  $('#load').click(function() {
    // alert($('#cmd').val());
    // $.ajax('/load', {'data':{'cmd':$('#cmd').val()}, success:function(data, textStatus, jqXHR){
    //   $('#svg').text(data);
    // }});
    $.getJSON('/load', {'cmd':$('#cmd').val()}, function(data, textStatus, jqXHR){
      $(data).each(function(i) {
        var cmd = $('#cmd').val();
        var txt = $('#a'+i);
        var s = data[i];
        $(txt).text(cmd[i+1]);
        $(txt).attr('x', s[0]+'em');
        $(txt).attr('y', s[1]+'em');
        $(txt).attr('transform', 'scale('+s[2]+','+s[3]+')');
        $('#x'+i).attr('value', s[0]);
        $('#y'+i).attr('value', s[1]);
        $('#h'+i).attr('value', s[2]);
        $('#v'+i).attr('value', s[3]);
      })
    });
  });
  
  $('#update').click(function() {
    var cmd = $('#cmd').val();
    $('#a0').text(cmd[1]);
    $('#a1').text(cmd[2]);
  });
  
  $('#x0').change(function(){
    $('#a0').attr('x', $('#x0').val()+'em');
    $('#scales0').text('['+$('#x0').val()+', '+$('#y0').val()+', '+$('#h0').val()+', '+$('#v0').val()+']');
  });
  
  $('#y0').change(function(){
    $('#a0').attr('y', $('#y0').val()+'em');
    $('#scales0').text('['+$('#x0').val()+', '+$('#y0').val()+', '+$('#h0').val()+', '+$('#v0').val()+']');
  });
  
  $('#x1').change(function(){
    $('#a1').attr('x', $('#x1').val()+'em');
    $('#scales1').text('['+$('#x1').val()+', '+$('#y1').val()+', '+$('#h1').val()+', '+$('#v1').val()+']');   
  });
  
  $('#y1').change(function(){
    $('#a1').attr('y', $('#y1').val()+'em');
    $('#scales1').text('['+$('#x1').val()+', '+$('#y1').val()+', '+$('#h1').val()+', '+$('#v1').val()+']');
  });
  
  $('#h0').change(function(){
    $('#a0').attr('transform', 'scale('+$('#h0').val()+','+$('#v0').val()+')');
    $('#scales0').text('['+$('#x0').val()+', '+$('#y0').val()+', '+$('#h0').val()+', '+$('#v0').val()+']');
  });

  $('#v0').change(function(){
    $('#a0').attr('transform', 'scale('+$('#h0').val()+','+$('#v0').val()+')');
    $('#scales0').text('['+$('#x0').val()+', '+$('#y0').val()+', '+$('#h0').val()+', '+$('#v0').val()+']');
  });

  $('#h1').change(function(){
    $('#a1').attr('transform', 'scale('+$('#h1').val()+','+$('#v1').val()+')');
    $('#scales1').text('['+$('#x1').val()+', '+$('#y1').val()+', '+$('#h1').val()+', '+$('#v1').val()+']');
  });

  $('#v1').change(function(){
    $('#a1').attr('transform', 'scale('+$('#h1').val()+','+$('#v1').val()+')');
    $('#scales1').text('['+$('#x1').val()+', '+$('#y1').val()+', '+$('#h1').val()+', '+$('#v1').val()+']');
  });
  
  $('#operators a').click(function(e){
    $('#cmd').attr('value', $(e.target).text()+$('#cmd').attr('value').slice(1));
    return false;
  });
})