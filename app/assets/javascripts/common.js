(function($_){
  $(document).on('click','.top', function(){
    $("html, body").animate({ scrollTop: 0 }, "slow");
    return false;
  });

  $_.page_loader = function(argument){
    this.page = 2;
    this.url = argument['url'];
    this.per_page = argument['per_page'];
    this.type = argument['type'],
    this.query = argument['query'],
    this.kind = argument['kind']
  };

  $_.page_loader.prototype.is_end = function(){
    var v = parseInt(gon.total_cnt/this.per_page)+1 , args = arguments;
    if(gon.total_cnt != 0 && v  == this.page-1){
      $('.more_load').text("끝입니다.");
      return true;
    }
    return false;
  };

  $_.page_loader.prototype.load = function(){
    var that = this, template, data, target, html;
    if($_.page_loader.prototype.is_end.call(this)) return;
    $.ajax({
      type: _.isUndefined(this.type)?'GET':this.type,
      url: this.url+"?page="+this.page,
      async: false,
      data: {search:{title_or_gift_or_description_contains:this.query}},
      success: function(items){
        template = _.template(
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
          "</a><span class='gift'><%=gift%></span>"+
          "</div>"+
          "</div>"+
          "</li>");
        for(var i=1;i<=items.length;i++){
          data = {};
          target = items[i-1];
          if(target != null){
            if(target.image_file_size != null){
              if(that.kind == 'coupon'){
                data.image = "http://eventstore.co.kr/images/coupons/"+target.id+"/"+target.id+"_medium.jpg";
              }else{
                data.image = "http://eventstore.co.kr/images/products/"+target.id+"/"+target.id+"_medium.jpg";
              }
            }else{
              data.image = "http://eventstore.co.kr/assets/noimage_small_bg.jpg";
            }
            data.rank = (that.page-1)*that.per_page+i;
            data.hits = target.hits;
            data.publisher = target.publisher;
            data.id = target.id;
            data.title = target.title;
            data.gift = target.gift.replace(/\n/g,"<br/>");
            if(target.expire_days == '0'){
              data.expire_days = 'day';
            }else{
              data.expire_days = target.expire_days;
            }
            html = template(data);
            $("ul.events_list").append(html);
          }
        }
        that.page++;
      }
    });
  };

  $_.page_loader.prototype.group_load = function(){
    var that = this, productsTemplate, groupTemplate, items, data, productData, group, html, products, sum, productHtml;
    if($_.page_loader.prototype.is_end.call(this)) return;
    $.ajax({
      url: "/products/story.json?page="+this.page,
      async: false,
      success: function(items){
        productsTemplate = _.template(
          "<li>"+
          "<img src='<%=image%>'>"+
          "<div class='info'>"+
          "<a href='<%=link%>'>"+
          "<span class='title'><%=title%></span>"+
          "</a>"+
          "<span class='hits'>조회 수: <%=hits%></span>"+
          "<span class='publisher'>주최: <%=publisher%></span>"+
          "<span class='gift'><%=gift%></span>"+
          "<span class='end_date'>종료일자: <%=endDate%></span>"+
          "</div>"+
          "</li>"
          );

        groupTemplate = _.template(
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
        for(var i=0; i<items.length;i++){
          data = {};productData = {};group = items[i];html = '';
          if(group != null){
            products = group.products;sum = 0;
            data.title = group.title;
            data.desc = group.desc;
            productHtml = "<ul class='events'>";
            for(var j=0; j<products.length;j++){
              sum += products[j].hits;
              productData.title = products[j].title;
              productData.publisher = products[j].publisher;
              if(products[j].image_file_size != null){
                productData.image = "http://eventstore.co.kr/images/products/"+products[j].id+"/"+products[j].id+"_medium.jpg";
              }else{
                productData.image = "http://eventstore.co.kr/assets/noimage_small_bg.jpg";
              }
              productData.gift = products[j].gift.replace(/\n/g, '<br />');
              productData.link = "http://eventstore.co.kr/products/"+products[j].id;
              productData.endDate = products[j].end_date;
              productData.hits = products[j].hits;
              productHtml += productsTemplate(productData);
            }
            productHtml += "</ul>";
            data.count = sum;
            html = "<li>"+ groupTemplate(data) + productHtml + "</li>";
            $(".popular_events_list > ul").append(html);
          }
        }
        that.page++;
      }
    })
  };
  $_.page_loader.prototype.categories_load = function(){
    var that = this, data, template;
    if($_.page_loader.prototype.is_end.call(this)) return;
    $.ajax({
      url: this.url+"?page="+this.page,
      async: false,
      dataType: 'json',
      success: function(items){
        template = _.template(
          "<li>"+
          "<a href='<%=link%>'>"+
          "<img src='<%=image%>'>"+
          "</a><a href='<%=link%>'>"+
          "<span class='title'><%=title%></span>"+
          "</a><span class='gift'><%=gift%></span>"
        );
        for(var i=0; i<items.length; i++){
          data = {};target = items[i];
          if(!_.isNull(target)){
            data.image = "/images/products/"+target.id+"/"+target.id+"_original.jpg";
            data.link = "/products/"+target.id;
            data.title = target.title;
            data.gift = target.gift;
            $(".products ul").append(template(data));
          }
        }
        that.page++;
      }
    })
  };
  
  $_.set_cookie = function(cname, cvalue, exdays){
    var d = new Date();
    d.setTime(d.getTime()+(exdays*24*60*60*1000));
    var expires = "expires="+d.toGMTString();
    document.cookie = cname + "=" + cvalue + ";path=/;" + expires;
  };

  $_.get_cookie = function(cname){
    var name = cname + "=";
    var ca = document.cookie.split(';');
    for(var i=0; i<ca.length; i++){
      var c = ca[i].trim();
      if (c.indexOf(name)==0) return c.substring(name.length,c.length);
    }
    return "";
  };

  $_.delete_cookie = function(cookieName){
    var expireDate = new Date();
    expireDate.setDate( expireDate.getDate() - 1 );
    document.cookie = cookieName + "= " + "; expires=" + expireDate.toGMTString() + "; path=/";
  };

  $_.local_storage_set = function(k,v){
    if(!('localStorage' in window) || window['localStorage'] == null){
      return false;
    }
    if(_.isEmpty(localStorage[k])){
      localStorage.setItem(k,v);
    }
  };

  $_.local_storage_get = function(k){
    if(_.isEmpty(localStorage[k])){
      return false;
    }else{
      return localStorage.getItem(k);
    }
  };

}).call(this,window);
