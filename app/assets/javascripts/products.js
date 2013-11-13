/*
setInterval(function(){
  $.ajax({
    type: "GET",
  url: "/rank",
  dataType: "JSON",
  async: true,
  success: function(data){
    var template = _.template("<li><span class='rank'><%=rank%></span><span class='title'> <%=title%></span></li>");
    //var items = $.parseJSON(data);
    var items = data;
    var result = [];
    for(var i=0;i<items.length;i++){
      var html = template({rank:i+1,title:items[i].title});
      result.push(html);
    }
    var i = 0;
    var interval = setInterval(function(){
      var replaceHtml = $(result[i]);
      var that = $('.aside .events li:nth-child('+(i+1)+')');
        that.animate({
          opacity: 0.0
        }, 1000, function () {
          $(this).replaceWith(replaceHtml);
          replaceHtml.slideDown(1000, 'linear');
        }); 
        i++;
        if( i >= 10) clearInterval(interval);
        }, 1000,result);
      },
      error: function(XMLHttpRequest, textStatus, errorThrown){
        //alert("실패");
      }
      })
},20000);
$(document).ready(function(){
  $(".btn-group a.btn, .product_info a, .info a, .events a").click(function(){
    var url = $(this).attr('href');
    window.location.href = url;
  });
});
*/
