$(function(){
  $(".detail").on('click', '.btn-success', function(){
    var productId = $(this).parent().find("#product_id").val();
    var userId = $(this).parent().find("#user_id").val();
    $.ajax({
      type: "POST",
      url: "/user_products", 
      data: {"user_product" : {"user_id":userId, "product_id":productId}},
      dataType: "JSON",
      async: false,
      success: function(data){
        if(typeof data.id != "undefined"){
          var dom = $(".detail .btn-success");
          dom.text("내 이벤트함에서 제거");
          dom.removeClass("btn-success");
          dom.addClass("btn-danger");
          var userProduct = "<input id='user_product_id' name='user_product_id' type='hidden' value="+data.id+" />";
          $(dom).after(userProduct);
        }
      },
      error: function(XMLHttpRequest, textStatus, errorThrown){
        alert("실패");
      }
    })
  })

  $(".detail").on('click', '.btn-danger',  function(){
    var productId = $(this).parent().find("#user_product_id").val();
    $.ajax({
      type: "delete",
      url: "/user_products/"+productId, 
      data: {},
      dataType: "JSON",
      async: false,
      success: function(data){
        var dom = $(".detail .btn-danger");
        dom.text("내 이벤트함에서 넣기");
        dom.removeClass("btn-danger");
        dom.addClass("btn-success");
      },
      error: function(XMLHttpRequest, textStatus, errorThrown){
        alert("실패");
      }
    })
  })
});
