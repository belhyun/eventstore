(function($_){
  $(document).on('click', "#search .glyphicon-search a img", function(e){
    e.preventDefault();
    $(".navbar-form").submit();
  });
}).call(this,window);
