(function($_){
  var ajax_request= function(args){
    $.ajax({
      type: args["method"],
      url: args["url"], 
      data: args["data"] || {},
      dataType: "JSON",
      async: false,
      success: function(data){
        args.success.call(null,data);
      },
      error: function(XMLHttpRequest, textStatus, errorThrown){
        alert("실패");
      }
    })
  }; 
  $(document).on('click', '.zzim', function(){
    if(_.isNull(gon.current_user)){
      if(confirm("로그인 하시겠습니까?")){
        $_.set_cookie('referer', encodeURI(document.URL), 1);
        location.href = "/auth/facebook";
        return;
      }
      return;
    }
    var args = {};
    args.method = "POST";
    args.url = "/user_products";
    args.data = {
      user_product: {
        user_id: gon.current_user.id,
        product_id: gon.product.id
      }
    };
    args.success = function(){
      var user_product = arguments[0];
      if(!_.isNull(user_product)){
        $(".zzim").text("찜 안할래요").removeClass("zzim").addClass("not-zzim");
        gon.userProduct = user_product;
      }
    };
    ajax_request.call(null, args);
  });

  $(document).on('click', '.not-zzim',  function(){
    var args = {};
    if(!_.isNull(gon.current_user)){
      args.method = "DELETE";
      args.url = "/user_products/"+gon.userProduct.id;
      args.success = function(){
        $(".not-zzim").text("찜하기").removeClass("not-zzim").addClass("zzim");
      };
      ajax_request.call(null,args);
    }
  });
}).call(this, window);
