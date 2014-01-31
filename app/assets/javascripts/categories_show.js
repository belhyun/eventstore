(function($_){
  var loader = new $_.page_loader({
    per_page: 5,
    url: $_.location.pathname+".json"
  });
  $(document).on('click','.more_load', function(e){
    e.preventDefault();
    loader.categories_load.call(loader);
  });
}).call(this, window);
