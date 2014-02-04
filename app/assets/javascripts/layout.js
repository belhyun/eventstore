(function($_){
  $("a.brand").click(function(){
    var url = $(this).attr('href');
    window.location.href = url;
  });

  $(document).on('click', "#sign-out a", function(e){
    e.preventDefault();
    $_.delete_cookie("referer");
    location.href = "/signout";
  });

  $(document).on('click', "#sign-in a", function(e){
    e.preventDefault();
    $_.set_cookie('referer', encodeURI(document.URL), 1);
    location.href = "/auth/facebook";
  });
}).call(this, window);
