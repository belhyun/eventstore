$(document).ready(function(){
  $("a.brand").click(function(){
    var url = $(this).attr('href');
    window.location.href = url;
  });
});
