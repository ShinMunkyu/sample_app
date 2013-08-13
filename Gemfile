source 'https://rubygems.org'
ruby '2.0.0'
#ruby-gemset=railstutorial_rails_4_0

gem 'rails', '4.0.0'

group :development, :test do
  gem 'sqlite3', '1.3.7'
  gem 'rspec-rails', '2.13.1'
end

#유저 인터렉샨을 시뮬레이트할 수 있도록 하는 애플리케이션 
#selenium은 capubera의 의존성이 있는 애플리케이
group :test do
  gem 'selenium-webdriver', '2.0.0'
  gem 'capybara', '2.1.0'
end

gem 'sass-rails', '4.0.0'
gem 'uglifier', '2.1.1'
gem 'coffee-rails', '4.0.0'
gem 'jquery-rails', '2.2.1'
gem 'turbolinks', '1.1.1'
gem 'jbuilder', '1.0.2'

group :doc do
  gem 'sdoc', '0.3.20', require: false
end

#Heroku에 배포하기 위한 설정
group :production do
  gem 'pg', '0.15.1'
  gem 'rails_12factor', '0.0.2'
end