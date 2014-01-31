(function($_){
  $(document).on('click','.top', function(){
    $("html, body").animate({ scrollTop: 0 }, "slow");
    return false;
  });

  $_.page_loader = function(argument){
    this.page = 2;
    this.url = argument['url'];
    this.per_page = argument['per_page'];
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
      url: this.url+"?page="+this.page,
      async: false,
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
          "</a>    경품: <span class='gift'><%=gift%></span>"+
          "</div>"+
          "</div>"+
          "</li>");
        for(var i=1;i<=items.length;i++){
          data = {};
          target = items[i-1];
          if(target != null){
            if(target.image_file_size != null){
              data.image = "http://eventstore.co.kr/images/products/"+target.id+"/"+target.id+"_medium.jpg";
            }else{
              data.image = "http://eventstore.co.kr/assets/noimage_small_bg.jpg";
            }
            data.rank = (that.page-1)*that.per_page+i;
            data.hits = target.hits;
            data.publisher = target.publisher;
            data.id = target.id;
            if(target.gift != null){
            }else{
              target.gift = "경품정보 없음";
            }
            data.title = target.title;
            data.gift = target.gift;
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
          "</a><span class='publisher'>주최: <%=publisher%></span>"+
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
              productData.gift = products[j].gift;
              productData.link = "http://eventstore.co.kr/products/"+products[j].id;
              productData.endDate = products[j].end_date;
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
}).call(this,window);
