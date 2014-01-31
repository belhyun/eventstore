(function($_){
  var loader = new $_.page_loader({
    per_page: 2,
    url: "/products/story.json"
  });
  $(document).on('click','.more_load', function(e){
    e.preventDefault();
    loader.group_load.call(loader);
  });

  $(document).on('click', '.column-container .content .popular_events_list .products_title', function(e){
    var parent = $(this).parent(), events = parent.find(".events"), all_events = $(".column-container .content .popular_events_list .events"), index = parent.index();
    if(_.isEqual(events.css("display"),"block")){
      events.css("display","none");
    }else{
      events.css("display","block");
      all_events.each(function(l_index){
        if(!_.isEqual(index, l_index)) $(this).css("display","none");
      });
    }
  });
}).call(this, window);
