$(function(){
  $(document).on('click', '.zzim', function(){
    var productId = $(this).parent().find("#product_id").val();
    var userId = $(this).parent().find("#user_id").val();
    if(userId == null){
      alert("로그인이 필요한 서비스입니다.");
      return;
    }
    $.ajax({
      type: "POST",
      url: "/user_products", 
      data: {"user_product" : {"user_id":userId, "product_id":productId}},
      dataType: "JSON",
      async: false,
      success: function(data){
        if(typeof data.id != "undefined"){
          var dom = $(".zzim");
          dom.text("찜 안할래요");
          dom.removeClass("zzim");
          dom.addClass("not-zzim");
          $("#user_product_id").remove();
          var userProduct = "<input id='user_product_id' name='user_product_id' type='hidden' value="+data.id+" />";
          $(dom).after(userProduct);
        }
      },
      error: function(XMLHttpRequest, textStatus, errorThrown){
        alert("실패");
      }
    })
  })

  $(document).on('click', '.not-zzim',  function(){
    var productId = $(this).parent().find("#user_product_id").val();
    $.ajax({
      type: "delete",
      url: "/user_products/"+productId, 
      data: {},
      dataType: "JSON",
      async: false,
      success: function(data){
        var dom = $(".not-zzim");
        dom.text("찜하기");
        dom.removeClass("not-zzim");
        dom.addClass("zzim");
      },
      error: function(XMLHttpRequest, textStatus, errorThrown){
        alert("실패");
      }
    })
  })
});
