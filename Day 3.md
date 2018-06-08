# Day 3

### 목표

* Form 사용하기

* GET과 POST

* Parameter(wildcard)

* 구글/ 네이버 검색창 만들기

* fake op.gg 만들기

  

### 새로운 폴더에 sinatra 프로젝트 넣기

* `app.rb` 파일 생성 후 views 폴더 생성

* `sinatra`와 `sinatra-reloader` 잼 설치

  

>  app.rb

```ruby
require 'sinatra'
require 'sinatra/reloader'


get '/' do
    erb :app
end
```



> app.erb

```html
<html>
    <head></head>
    
    <body>
        <ul>
            <li><a href = "/numbers">
                Form 이용해 보기</a></li>
            <li><a href = "/form">
                GET과 POST</a></li>
            <li><a href = "/url/wild">
                Parameter(wildcard)</a></li>
            <li><a href = "/search">
                구글/네이버 검색창 만들기</a></li>
            <li><a href = "/op.gg">
                fake op.gg 만들기</a></li>
        </ul>
        
    </body>
    
</html>
```





### Form 사용하기

> app.rb

```ruby
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
```



> calculator.erb

```html
<ul>
    <li>합    : <%= @sum %></li>
    <li>차    : <%= @min %></li>
    <li>곱    : <%= @mul %></li>
    <li>나누기: <%= @div %></li>
</ul>
```



> numbers.erb

```html
<form action="/calculator">
    첫번째 숫자: <input type="text" name = "n1">
    두번째 숫자: <input type="text" name = "n2">
    <input type="submit" value="계산하기">
</form>
```

 form을 이용해서 calculator 페이지에 n1, n2 값을 입력받아 전달한다.



### GET과 POST



> app.rb

```ruby
id = "multi"
pw = "campus"

get '/form' do
    erb :form
end

post '/login' do
    if id.eql?(params[:id]) 
        # 비밀번호를 체크하는 로직
        if pw.eql?(params[:pw])
            redirect '/complete'
        else
            @msg = "비밀번호 틀림"
            redirect '/error'
        end
    else
        # ID가 존재하지 않습니다.
        @msg = "ID 없음"
        redirect '/error'
    end
end
#계정이 존재하지 않거나, 비밀번호가 틀린 경우
get '/error' do
    erb :error
end

#로그인 완료된 곳
get '/complete' do
    erb :complete
end

```



> form.erb

```html
<form  action = "/login" method="POST">
    아이디:<input type="text" name = "id">
    비밀번호:<input type="password" name = "pw">
    <input type="submit" value = "로그인">
</form>

```

######  form은 post 방식으로 `/login`에 데이터를 전송하게 된다. 그럼 `post '/login' `에 정의한대로 명령을 실행한다. 

###### 

> error.erb

```html
<h1><%= @msg %></h1>
```

 `app.rb`에서 redirect로 `/error`을 실행하게 되어있다. 따라서 기존의 정보는 유지되지 않으므로 `@msg`는 아무것도 출력하지 않게 된다.



> complete.erb

```html
<h1>로그인 성공</h1>
```

 로그인 성공시 위와 같은 문서를 출력한다.



> app.rb

```ruby
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
```

 만약 에러 유형을 보고 싶다면 위와 같이 `redirect`에 직접 파라메터 값을 주고 그것을 이용한다.





### 검색창

* GET 방식과 POST 방식으로 검색창을 만든다.



> app.rb

```ruby
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
```

 POST 방식으로 데이터를 받을 때, 주의할 점은 파라메터를 한글로 받을 경우 인코딩을 해주어야 한다는 것이다. `uri gem`을 require하여 uri를 인코딩 하도록 한다.



> search.erb

```html
<form action = 'https://www.google.co.kr/search'>
    구글    <input type="text" name = "q">
    <input type='submit' value = "검색">
</form>

<form action = 'https://search.naver.com/search.naver'>
    네이버    :<input type="text" name = "query">
    <input type='submit'  value = "검색">
</form>

<form method="POST">
    <input type="hidden" name="engine" value="naver">
    <input type="text" name="query" placeholder="네이버 검색">
    <input type="submit" value="검색">
</form>

<form method="POST">
    <input type="hidden" name="engine" value="google">
    <input type="text" name="q" placeholder="구글 검색">
    <input type="submit" value="검색">
</form>
```





### op.gg 

* 유저 이름을 입력받아 전적을 op.gg로 직접 보여준다.
* 유저 이름을 입력받아 현재 페이지에 전적(승, 패)를 보여준다.
* `form tag`의 `action`은 단 하나만 사용한다.



> app.rb

```ruby
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
```

 op.gg에 직접 전적을 보여주는 경우는 redirect를 사용한다.

 하지만 간적접으로 보여주어야 하는 경우는 웹페이지를 크롤링하여 가져오도록 한다.



> op_gg.erb

```html
<form action = '/op-result'>
    <select name="option">
        <option value="Direct">op.gg에서 보기</option>
        <option value="Indirect">여기에서 보기</option>
    </select>
    <input type="text" name = "id">
    <input type="submit" value = "검색">
</form>
<% if params[:id] %>
<ul>
    <li><%= params[:id]%>님의 전적</li>
    <li><%= @win %></li>
    <li><%= @lose %></li>
</ul>
<% end %>
```

 `<% %>`를 사용하여 ruby 문법을 사용할 수 있다. `<% if params[:id] %>`를 사용하면, 사용자가 전적을 한 번이라도 검색하기 전까지 필요없는 문서를 숨길 수 있다.