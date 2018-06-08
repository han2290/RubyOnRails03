require 'sinatra'
require 'sinatra/reloader'
require 'uri'
require 'httparty'
require 'nokogiri'
require 'rest-client'

get '/' do
    erb :app
end

get '/calculator' do
    num1 = params[:n1].to_f
    num2 = params[:n2].to_f
    @sum = num1 + num2
    @min = num1 - num2
    @mul = num1 * num2
    @div = num1 / num2
    erb :calculator
end

get '/numbers' do
    erb :numbers
end


get '/form' do
    erb :form
end

id = "multi"
pw = "campus"

post '/login' do
    if id.eql?(params[:id]) 
        # 비밀번호를 체크하는 로직
        if pw.eql?(params[:pw])
            redirect '/complete'
        else
            #@msg = "비밀번호 틀림"
            #@msg는 인스턴스이기 때문에 
            redirect '/error?err_co=1'
        end
    else
        # ID가 존재하지 않습니다.
       # @msg = "ID 없음"
        redirect '/error?err_co=2'
    end
end

#계정이 존재하지 않거나, 비밀번호가 틀린 경우
get '/error' do
    if params[:err_co].to_i==1
        @msg = "에러코드 1"
    elsif params[:err_co].to_i==2
        @msg = "에러코드 2"
    else
        @msg = "에러코드 non"
    end
    erb :error
end

#로그인 완료된 곳
get '/complete' do
    erb :complete
end


#검색창
get '/search' do
    erb :search
end

post '/search' do
    puts params[:engine]
    case params[:engine]
    when "naver"
        url = URI.encode("https://search.naver.com/search.naver?query=#{params[:query]}")
        redirect url
    when "google"
        url = URI.encode("https://www.google.com/search?q=#{params[:q]}")
        redirect url
    end
end

get '/op-gg' do
    erb :op_gg
end

get '/op-result' do
    url = URI.encode("http://www.op.gg/summoner/userName=#{params[:id]}")
    case params[:option]
    when "Direct"
        redirect url
    when "Indirect"
        #RestClient를 통해 op.gg에서 검색 결과 페이지를 크롤링
        #기존에는 nokogiri를 이용해 크롤링
        #검색 결과를 페이지에서 보여주기 위한 변수 선언
        url = RestClient.get(url)
        result = Nokogiri::HTML(url)
        win = result.css("span.win")[0]
        lose = result.css("span.lose")[0]
        @win = win.text + "승"
        @lose = lose.text + "패"
        
        erb :op_gg
    end
    
end