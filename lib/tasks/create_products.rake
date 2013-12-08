namespace :create do 

  task :run_all do 
    Rake::Task["create:epass"].invoke
    Rake::Task["create:gift_auto"].invoke
    #Rake::Task["create:facebook"].invoke
    Rake::Task["create:eventbook"].invoke
    Rake::Task["create:remove"].invoke
  end

  desc "gift auto create products"
  task :gift_auto => :environment do
    require 'nokogiri'
    require 'open-uri'
    require 'date'

    5.downto(1) do |i|
      url = "http://www.giftauto.co.kr/event/event_list.php?page=#{i}"
      doc = Nokogiri::HTML(open(url))
      result = Array.new
      doc.search(".board_list tr").each do |item|
        object = Object.new
        tmp = Array.new
        node = item.xpath("./td").each do |sub_item|
          images = sub_item.xpath("./a/@href")
          images.each do |link|
            unless tmp.include?(link.inner_text)
              if link.inner_text.match('javascript').nil?
                object.instance_variable_set(:@product_id,link.inner_text.split('&')[1].split('=')[1]
                                            )
                object.instance_variable_set(:@link, "http://www.giftauto.co.kr/#{link.inner_text}")
              end
              tmp << link.inner_text
            end
          end
        end
        object.instance_variable_set(:@title, item.search(".subject").text)
        item.search(".comp").each do |sub_item|
          if !sub_item.children[0]["href"].nil?
            key = :@publisher
          elsif !sub_item.children[0].text.empty?
            key = :@join_method
          end
          if !key.nil?
            object.instance_variable_set(key, sub_item.children[0].text)
          end
        end
        object.instance_variable_set(:@end_date, (item.search(".datetime").text).gsub(/-/,""))
        if !object.instance_variable_get(:@link).nil?
          detail_url = "http://www.giftauto.co.kr/event/event_detail.php?event_uid=#{object.instance_variable_get(:@product_id)}"
          detail_doc = Nokogiri::HTML(open(detail_url))
          giftType = detail_doc.search(".table_all tr:nth-child(4) td:nth-child(4)")
          if !giftType[0].nil?
            object.instance_variable_set(:@gift_type, giftType[0].children.text)
          end
          desc = detail_doc.search(".table_all tr:nth-child(2) td:nth-child(2)")
          if !desc[0].nil?
            object.instance_variable_set(:@desc, desc[0].children.text)
          end
          gift = detail_doc.search(".table_all tr:nth-child(7) td:nth-child(2)")
          if !gift[0].nil?
            giftResult = String.new
            target = gift[0].children.text.split("\n")
            target.each_with_index do |gift,index|
              if target.count > index + 1
                giftResult += gift.squish + ", "
              else
                giftResult += gift.squish
              end
            end
            object.instance_variable_set(:@gift, giftResult)
          end
          publisher = detail_doc.search(".table_all tr:nth-child(10) td:nth-child(2)")
          if !publisher[0].nil?
            object.instance_variable_set(:@publisher, publisher[0].children.text)
          end
          duringDate = detail_doc.search(".table_all tr:nth-child(9) td:nth-child(2)")
          if !duringDate[0].nil?
            object.instance_variable_set(:@start_date, (duringDate[0].children.text.split("~")[0]).gsub(/-/,"").rstrip)
          end
          regDate = detail_doc.search(".table_all tr:nth-child(3) td:nth-child(2)")
          if !regDate[0].nil?
            object.instance_variable_set(:@reg_date, regDate[0].children.text.to_time)
          end
        end
        object.instance_variable_set(:@enterprise_id, 1)
        if object.instance_variable_get(:@gift).nil?
          object.instance_variable_set(:@gift, "경품정보가 제공되지 않습니다.")
        end
        result << object
      end
      result.shift
      result.each do |item|
        if(!item.nil?)
          product = Product.find_or_create_by_ex_id_and_enterprise_id(
            :title => item.instance_variable_get(:@title),
            :publisher => item.instance_variable_get(:@publisher),
            :join_method => item.instance_variable_get(:@join_method),
            :link => item.instance_variable_get(:@link),
            :end_date => item.instance_variable_get(:@end_date),
            :start_date => item.instance_variable_get(:@start_date),
            :ex_id => item.instance_variable_get(:@product_id),
            :gift => item.instance_variable_get(:@gift),
            :gift_type => item.instance_variable_get(:@gift_type),
            :enterprise_id => item.instance_variable_get(:@enterprise_id),
            :reg_date => item.instance_variable_get(:@reg_date),
            :description => item.instance_variable_get(:@desc)
          )
        end
        totalPoint = 100;
        totalUserCnt = 0;
        gift = item.instance_variable_get(:@gift)
        unless gift.nil?
          getUserCnt = item.instance_variable_get(:@gift).scan(/\d*명/)
          if getUserCnt.count > 0
            getUserCnt.each do |cnt|
              totalUserCnt += cnt.split(/[^\d]/).join('').to_i
            end
          end
        end
        endDate = item.instance_variable_get(:@end_date)
        if totalUserCnt == 0
          totalPoint += (getParticipatePoint(totalUserCnt)*0.2).to_int
          totalPoint += (getDiffDayPoint(endDate)*1.8).to_int
        else
          totalPoint += getParticipatePoint(totalUserCnt)
          totalPoint += getDiffDayPoint(endDate)
        end
        if $redis.zscore('PRODUCTS_RANKING', product.id).nil? && !gift.nil? && !endDate.nil? && totalUserCnt != 0
          $redis.zadd('PRODUCTS_RANKING', totalPoint, product.id)
        end
      end
    end
  end

  desc "facebook create products"
  task :facebook => :environment do
    require 'open-uri'
    require 'koala'
    require 'json'

    user = User.find(3)
    accToken = user.acc_token
    @graph = Koala::Facebook::API.new(accToken)
    events = @graph.get_object("search?q=이벤트&type=event")
    events.each do |event|
      detailEvent = @graph.get_object(event["id"])
      exId = detailEvent["id"]
      if detailEvent.has_key?("owner")
        publisher = detailEvent["owner"]["name"]
      end
      endDate = detailEvent["start_time"].gsub(/-/,"")[0, 8]
      place = detailEvent["location"]
      unless detailEvent['description'].nil?
        desc = detailEvent["description"].squish
      end
      title = detailEvent["name"]
      link = "http://facebook.com/"+detailEvent["id"]
      if !title.nil?
        product = Product.find_or_create_by_ex_id_and_enterprise_id(
          :title => title,
          :end_date => endDate,
          :ex_id => exId,
          :link => link,
          :publisher => publisher,
          :gift => "경품정보는 상세설명에 포함되어 있습니다.",
          :place => place,
          :description => desc,
          :enterprise_id => 5
        )
        totalPoint = 100
        totalUserCnt = 0

        matchData = desc.scan(/(\d+)명/) unless desc.nil?
        unless matchData.nil?
          matchData.each do |data|
            totalUserCnt += Integer(data[0])
          end
        end

        if totalUserCnt == 0
          totalPoint += (getParticipatePoint(totalUserCnt)*0.2).to_int
          totalPoint += (getDiffDayPoint(endDate)*1.8).to_int
        else
          totalPoint += getParticipatePoint(totalUserCnt)
          totalPoint += getDiffDayPoint(endDate)
        end

        if $redis.zscore('PRODUCTS_RANKING', product.id).nil? && !desc.nil? && !matchData.empty? && !endDate.nil? && totalUserCnt != 0
          $redis.zadd('PRODUCTS_RANKING', totalPoint, product.id)
        end
      end
    end
  end

  desc "eventbook create products"
  task :eventbook => :environment do
    require 'nokogiri'
    require 'open-uri'
    require 'date'

    5.downto(1) do |i|
      url = "http://eventbook.kr/bbs/board.php?bo_table=B01"
      doc = Nokogiri::HTML(open(url))
      doc.search(".mw_basic_list_gall").each do |event|
        mapper_url = "http://eventbook.kr/"+(event.search("table tr:nth-child(1) a")[0]['href'].sub /..\//, '')
        mapper_doc = Nokogiri::HTML(open(mapper_url))
        detail_url = /(?<http>(http:[\/][\/]|www.)([a-z]|[A-Z]|[0-9]|[\/.]|[~]|[_]|[?]|[=]|[&])*)/.match(mapper_doc.children[1].children[0].children[0].children.text)[0]
        detail_doc = Nokogiri::HTML(open(detail_url))
        title = detail_doc.search(".mw_basic_view_subject")[0].children.text.squish
        image = 'http://eventbook.kr/'+(detail_doc.search(".mw_basic_view_content img")[0].attributes['src'].text.sub /..\//, '')
        endDate = detail_doc.search(".mw_basic_view_title2")[0].children.text.squish
        endDate = /\d*-\d*-\d*/.match(endDate)[0].gsub(/-/,"").rstrip
        exId = detail_url.split('&')[1].split('=')[1]
        if !title.nil? && !image.nil?
          product = Product.find_or_create_by_ex_id_and_enterprise_id(
            :title => title,
            :image_url => image,
            :end_date => endDate,
            :description => "상세정보는 이벤트 이미지에 포함되어 있습니다.",
            :gift => "경품정보는 이벤트 이미지에 포함되어 있습니다.",
            :ex_id => exId,
            :link => detail_url,
            :enterprise_id => 3
          )
          totalPoint = 100
          totalUserCnt = 0
          matchData = /(\d+,\d+)명/.match(title)
          unless matchData.nil?
            totalUserCnt += matchData[1].delete(',').to_i
          end
          matchData = title.match(/(\d+)만명/)
          unless matchData.nil?
            totalUserCnt = (matchData[1].delete(',').to_i)*10000
          end
          if totalUserCnt == 0
            totalPoint += (getParticipatePoint(totalUserCnt)*0.2).to_int
            totalPoint += (getDiffDayPoint(endDate)*1.8).to_int
          else
            totalPoint += getParticipatePoint(totalUserCnt)
            totalPoint += getDiffDayPoint(endDate)
          end

          if $redis.zscore('PRODUCTS_RANKING', product.id).nil? && !matchData.nil? && totalUserCnt != 0
            $redis.zadd('PRODUCTS_RANKING', totalPoint, product.id)
          end
        end
      end
    end
  end

  desc "epass create products"
  task :epass => :environment do
    require 'nokogiri'
    require 'open-uri'
    require 'date'

    5.downto(1) do |i|
      url = "http://www.e-pass.co.kr/event/all.asp"
      doc = Nokogiri::HTML(open(url))
      doc.search(".List_Item_03").each do |event|
        detail_id = /\d*-\d*-\d*-\d*/.match(event.search("a")[0].attributes["onclick"].text.split(",")[0])[0]
        detail_url = "http://www.e-pass.co.kr/event/all_info.asp?InNo=#{detail_id}"
        detail_doc = Nokogiri::HTML(open("http://www.e-pass.co.kr/event/all_info.asp?InNo=#{detail_id}"))
        unless !detail_doc.search(".Font_Bold_04")[0].nil?
          next
        end
        title = detail_doc.search(".Font_Bold_04")[0].children.text.squish
        desc = detail_doc.search("form td table~ table tr:nth-child(3) td+ td")[0].children.text.squish
        date = detail_doc.search("form td table~ table tr:nth-child(2) td+ td")[0].children[0].text.squish
        exid = detail_id.split('-')
        exid = exid[0] + exid[1] + exid[2] + exid[3]
        gift = ''
        
        2.upto(10) do |j|
          if !detail_doc.search("form td td").search("tr:nth-child(#{j}) td:nth-child(2)")[0].nil?
            gift += detail_doc.search("form td td").search("tr:nth-child(#{j}) td:nth-child(2)")[0].children.text.squish
            giftCnt = detail_doc.search("form td td").search("tr:nth-child(#{j}) td:nth-child(3)")[0]
            if !giftCnt.nil?
              gift += "("+giftCnt.children.text.squish+"명)"
            end
            gift += ', '
          end
        end
=begin
        if !detail_doc.search("form td td").search("tr:nth-child(2) td:nth-child(2)")[0].nil?
          gift += detail_doc.search("form td td").search("tr:nth-child(2) td:nth-child(2)")[0].children.text.squish
          giftCnt = detail_doc.search("form td td").search("tr:nth-child(2) td:nth-child(3)")[0]
          if !giftCnt.nil?
            gift += "("+giftCnt.children.text.squish+"명)"
          end
          gift += ', '
        end
        if !detail_doc.search("form td td").search("tr:nth-child(3) td:nth-child(2)")[0].nil?
          gift += detail_doc.search("form td td").search("tr:nth-child(3) td:nth-child(2)")[0].children.text.squish
          giftCnt = detail_doc.search("form td td").search("tr:nth-child(3) td:nth-child(3)")[0]
          if !giftCnt.nil?
            gift += "("+giftCnt.children.text.squish+"명)"
          end
          gift += ', '
        end
        if !detail_doc.search("form td td").search("tr:nth-child(4) td:nth-child(2)")[0].nil?
          gift += detail_doc.search("form td td").search("tr:nth-child(4) td:nth-child(2)")[0].children.text.squish
          giftCnt = detail_doc.search("form td td").search("tr:nth-child(4) td:nth-child(3)")[0]
          if !giftCnt.nil?
            gift += "("+giftCnt.children.text.squish+"명)"
          end
          gift += ', '
        end
        if !detail_doc.search("form td td").search("tr:nth-child(5) td:nth-child(2)")[0].nil?
          gift += detail_doc.search("form td td").search("tr:nth-child(5) td:nth-child(2)")[0].children.text.squish
          giftCnt = detail_doc.search("form td td").search("tr:nth-child(5) td:nth-child(3)")[0]
          if !giftCnt.nil?
            gift += "("+giftCnt.children.text.squish+"명)"
          end
          gift += ', '
        end
        if !detail_doc.search("form td td").search("tr:nth-child(6) td:nth-child(2)")[0].nil?
          gift += detail_doc.search("form td td").search("tr:nth-child(6) td:nth-child(2)")[0].children.text.squish
          giftCnt = detail_doc.search("form td td").search("tr:nth-child(6) td:nth-child(3)")[0]
          if !giftCnt.nil?
            gift += "("+giftCnt.children.text.squish+"명)"
          end
          gift += ', '
        end
=end
        if gift[gift.length-2] == ','
          gift = gift.chop.chop
        end
        publisher = detail_doc.search("form td td a").children.text
        endDate = date.split("~")[1].split(/[^\d]/).join('')
        if gift.nil?
          gift = "경품정보가 제공되지 않습니다"
        end
        if !title.nil?
          product = Product.find_or_create_by_ex_id_and_enterprise_id(
            :title => title,
            :description => desc,
            :end_date => endDate,
            :ex_id => exid,
            :link => detail_url,
            :gift => gift ,
            :publisher => publisher,
            :enterprise_id => 4
          )
          #경품확률이 높을 경우 배당점수 높음
          totalPoint = 100;
          getUserCnt = gift.scan(/\((\d*)명\)/)
          totalUserCnt = 0;
          if getUserCnt.count > 0
            getUserCnt.each do |cnt|
              totalUserCnt += cnt.split(/[^\d]/).join('').to_i
            end
          end
          if totalUserCnt == 0
            totalPoint += (getParticipatePoint(totalUserCnt)*0.2).to_int
            totalPoint += (getDiffDayPoint(endDate)*1.8).to_int
          else
            totalPoint += getParticipatePoint(totalUserCnt)
            totalPoint += getDiffDayPoint(endDate)
          end

          if $redis.zscore('PRODUCTS_RANKING', product.id).nil? && totalUserCnt != 0
            $redis.zadd('PRODUCTS_RANKING', totalPoint, product.id)
          end
        end
      end
    end
  end
  desc "removeExpireProducts" 
  task :remove => :environment do
    Product.where("end_date < now()").each do  |product|
      $redis.zrem(Rails.application.config.rank_key, product.id)
    end
  end

  desc "in the movie create products" 
  task :in_the_movie => :environment do
    require 'nokogiri'
    require 'open-uri'

    url = "http://inthe-movie.com/events/"
    doc = Nokogiri::HTML(open(url))
    result = Array.new
    doc.search(".event_item_row ul li").each do |item|
      object = Object.new
      link = item.search("a")[0].attributes['href'].text
      object.instance_variable_set(:@link, "http://inthe-movie.com#{link}")
      object.instance_variable_set(:@ex_id, link[/[0-9\.]+/]);
      object.instance_variable_set(:@title, item.search("strong").text)
      if !item.search("dl dd")[0].nil?
        gift_date = item.search("dl dd")[0].text
        object.instance_variable_set(:@gift_date, gift_date)
      end
      if !item.search("dl dd")[1].nil?
        max_cnt = item.search("dl dd")[1].text
        object.instance_variable_set(:@max_cnt, max_cnt)
      end
      if !item.search("dl dd")[2].nil?
        place = item.search("dl dd")[2].text
        object.instance_variable_set(:@place, place)
      end
      if !item.search("dl dd")[3].nil?
        announce = item.search("dl dd")[3].text
        object.instance_variable_set(:@announce, announce)
      end
      object.instance_variable_set(:@enterprise_id, 2)
      result << object
    end
    result.each do |item|
      if(!item.nil?)
        product = Product.find_or_create_by_ex_id_and_enterprise_id(
          :title => item.instance_variable_get(:@title),
          :link => item.instance_variable_get(:@link),
          :gift_date => item.instance_variable_get(:@gift_date),
          :ex_id => item.instance_variable_get(:@ex_id),
          :max_cnt => item.instance_variable_get(:@max_cnt),
          :place => item.instance_variable_get(:@place),
          :announce => item.instance_variable_get(:@announce),
          :enterprise_id => item.instance_variable_get(:@enterprise_id),
          :publisher => "인더무비"
        )
        if $redis.zscore('PRODUCTS_RANKING', product.id).nil?
          $redis.zadd('PRODUCTS_RANKING', 100, product.id)
        end
      end
    end
  end
  def getDiffDayPoint(endDate)
    if endDate.nil?
      randNum = rand(1..100)
      remain = randNum%10
      return randNum-remain
    end
    diffDays = (((endDate.to_time - Time.zone.now)/1.day)+2).to_i
    if diffDays < 0
      -99999
    elsif diffDays == 0
      100
    elsif diffDays >= 50
      0
    else
      100 - (diffDays/5+1)*10
    end
  end

  def getParticipatePoint(cnt)
    if cnt == 0
      randNum = rand(1..100)
      remain = randNum%5
      randNum-remain
    else
=begin
      if cnt < 11
        cnt = 10
      elsif cnt < 21
        cnt = 20
      elsif cnt < 31
        cnt = 30
      elsif cnt <41
        cnt = 40
      elsif cnt < 51
        cnt = 50
      elsif cnt < 61
        cnt = 60
      elsif cnt < 71
        cnt = 70
      elsif cnt < 81
        cnt = 80
      elsif cnt < 91
        cnt = 90
      else
        cnt = 100
      end
=end
      #quot = ((cnt/10).to_int)*10
      if cnt > 100
        cnt = 100 + cnt/100
      else
        cnt
      end
    end
  end
end
