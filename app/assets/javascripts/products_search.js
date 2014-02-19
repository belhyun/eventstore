(function($_){
  $(document).ready(function(){
    var loader = new $_.page_loader({
      per_page: 10,
      url: "/products/search.json",
      query: gon.query,
      type: 'POST'
    });

    $(document).on('click','.more_load', function(e){
      e.preventDefault();
      loader.load.call(loader);
    });
  });
}).call(this, window);
