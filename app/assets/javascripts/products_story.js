var page = 2;
var totalCnt = 0;
$(document).on('click', '.more_load', function(event){
  event.preventDefault();
  var v = parseInt(totalCnt/2)+1;
  if(totalCnt != 0 && v  == page){
    $('.more_load').text("끝입니다.");
    return;
  } 
  $.ajax({
    url: "/products/story.json?page="+page,
    async: false,
    success: function(json){
      totalCnt = json.total_cnt;
      var productsTemplate = _.template(
        "<li>"+
        "<img src='<%=image%>'>"+
        "<div class='info'>"+
        "<a href='<%=link%>'>"+
        "<span class='title'><%=title%></span>"+
        "</a><span class='publisher'>주최: <%=publisher%></span>"+
        "<span class='gift'><%=gift%></span>"+
        "<span class='end_date'>종료일자: <%=endDate%></span>"+
        "</div>"+
        "</li>"
        );

      var groupTemplate = _.template(
        "<div class='products_title'>"+
        "<div class='text'>"+
        "<h4><a href='#none'><%=title%></a></h4>"+
        "<h5><a href='#none'><%=desc%></a></h5>"+
        "</div>"+
        "<div class='counts'>"+
        "<span class='view_counts'><%=count%></span>"+
        "<span class='view_text'>조회 수</span>"+
        "</div>"+
        "</div>"
        );

      var items = json.groups;
      for(var i=0; i<items.length;i++){
        var data = {};
        var productData = {};
        var group = items[i];
        var html = '';
        if(group != null){
          var products = group.products;
          var sum = 0;
          data.title = group.title;
          data.desc = group.desc;
          var productHtml = "<ul class='events'>";
          for(var j=0; j<products.length;j++){
            sum += products[j].hits;
            productData.title = products[j].title;
            productData.publisher = products[j].publisher;
            if(products[j].image_file_size != null){
              productData.image = "http://eventstore.co.kr/public/images/products/"+products[j].id+"/"+products[j].id+"_medium.jpg";
            }else{
              productData.image = "http://eventstore.co.kr/assets/noimage_small_bg.jpg";
            }
            productData.gift = products[j].gift;
            productData.link = "http://eventstore.co.kr/products/"+products[j].id;
            productData.endDate = products[j].end_date;
            productHtml += productsTemplate(productData);
          }
          productHtml += "</ul>";
          data.count = sum;
          var html = "<li>"+ groupTemplate(data) + productHtml + "</li>";
          $(".popular_events_list > ul").append(html);
        }
      }
      page++;
    }
  })
});
