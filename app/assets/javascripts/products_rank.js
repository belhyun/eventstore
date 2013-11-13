var page = 2;
var totalCnt = 0;
$(document).on('click', '.more_load', function(event){
  event.preventDefault();
  var v = parseInt(totalCnt/10)+1;
  if(totalCnt != 0 && v  == page-1){
    $('.more_load').text("끝입니다.");
    return;
  } 
  $.ajax({
    url: "/products/rank.json?page="+page,
    async: false,
    success: function(json){
      totalCnt = json.total_cnt;
      var template = _.template(
        "<li>"+
        "<div class='rank'><span><%=rank%><span></span></span></div>"+
        "<div class='info'>"+
        "<img src='<%=image%>'>"+
        "<div class='extra'>"+
        "<div class='end_date'><span class='extra_top'>마감일</span>"+
        "<span class='extra_body'>D-<%=expire_days%></span></div>"+
        "<div class='counts'>"+
        "<span class='extra_top'>조회수</span><span class='extra_body'><%=hits%></span>"+
        "</div>"+
        "</div>"+
        "<div class='product_info'>"+
        "<div class='publisher'><%=publisher%></div>"+
        "<a href='/products/<%=id%>'>"+
        "<span class='title'><%=title%></span>"+
        "</a>    경품: <span class='gift'><%=gift%></span>"+
        "</div>"+
        "</div>"+
        "</li>");
      items = json.products;
      for(var i=1;i<=items.length;i++){
        var data = {};
        var target = items[i-1];
        if(target != null){
          if(target.image_file_size != null){
            data.image = "http://eventstore.co.kr/public/images/products/"+target.id+"/"+target.id+"_original.jpg";
          }else{
            data.image = "http://eventstore.co.kr/assets/noimage_small_bg.jpg";
          }
          data.rank = (page-1)*10+i;
          data.hits = target.hits;
          data.publisher = target.publisher;
          data.id = target.id;
          if(target.gift != null){
          }else{
            target.gift = "경품정보 없음";
          }
          if(target.title.length > 50){
          }
          data.title = target.title;
          data.gift = target.gift;
          if(target.expire_days == '0'){
            data.expire_days = 'day';
          }else{
            data.expire_days = target.expire_days;
          }
          var html = template(data);
          $("ul.events_list").append(html);
        }
      }
      page++;
    }
  });
});
