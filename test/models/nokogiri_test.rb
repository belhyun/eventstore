require 'rubygems'
require 'nokogiri'
require 'open-uri' 

url = "http://www.giftauto.co.kr/event_list.php"
doc = Nokogiri::HTML(open(url))
#puts doc.at_css("title").text
result = Array.new
doc.search(".board_list tr").each do |item|
 	object = Object.new
	tmp = Array.new

  node = item.xpath("./td").each do |sub_item|
    images = sub_item.xpath("./a/@href")
    images.each do |link|
      unless tmp.include?(link.inner_text)
        object.instance_variable_set(:@image, link.inner_text)
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
  object.instance_variable_set(:@end_date, item.search(".datetime").text)
  object.instance_variable_set(:@product_id, item.search(".num").text)
	result << object
  puts result[2].inspect
end
