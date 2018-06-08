require 'sinatra'
require 'sinatra/reloader'
require 'httparty'
require 'nokogiri'
require "json"


get "/menu" do
    #점심에는 ?를 먹고 저녁에는 ?을 드세요
    menu = ['20층', '편의점', '순남시레기','한솥', '토스트', '치킨', '피자']
    result=menu.sample(2)
    #puts 
    "점심은 " + result[0] + " 저녁은 " + result[1]
end

get "/lotto" do
    # 로또
    number = (1..45).to_a
    lotto = number.sample(6).sort
    
   
    "이번주 추천 로또 숫자는" +
    lotto.to_s + "입니다."

end

get "/kospi" do

    response = HTTParty.get('http://finance.daum.net/quote/kospi.daum')
    kospi = Nokogiri::HTML(response)
    result = kospi.css("#hyenCost > b")
    result.text
end




get "/check_lotto" do
    url = "http://m.nlotto.co.kr/common.do?method=getLottoNumber&drwNo=809"
    lotto = HTTParty.get(url)
    result = JSON.parse(lotto)
    numbers = []
    bonus = result["bnusNo"]
    result.each do |k, v|
        if k.include?("drwtNo")
            numbers << v
        end
    end
    
    #무작위 lotto 생성
    my_number = *(1..45)
    my_lotto = my_number.sample(6).sort
    count = 0
    numbers.each do |num| #보너스 번호
        count+=1 if my_lotto.include?(num)
    end
    # puts count
    bnusRs = false
    bnusRs = true if my_lotto.eql?(bonus)
    puts numbers.to_s + bonus.to_s
    puts my_lotto.to_s
    puts "결과: "+count.to_s + "/ " + bnusRs.to_s
    # if count == 6
    # elsif
    # else
    # end
end

get "/html" do
    "<html>
        <head></head>
        <body>Hello World</body>
    </html>
    "
end

get '/html_file' do
    @name = params[:name]
    #send_file 'views/my_first_html.html'
    erb :my_first_html#erb파일을 보낼때는 erb file를 쓴다.
end

get '/calculator' do
    num1 = params[:num1].to_f
    num2 = params[:num2].to_f
    
    @sum = num1 + num2
    @sub = num1 - num2
    @div = num1 / num2
    @mul = num1 * num2
    
    erb :calculator_html
    
end