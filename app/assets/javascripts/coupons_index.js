(function($_){
  var loader = new $_.page_loader({
    per_page: 10,
    url: "/coupons.json"
  });
  $(document).on('click','.more_load', function(e){
    e.preventDefault();
    loader.load.call(loader);
  });
}).call(this, window);
