module SessionsHelper
	def sign_in(user)
		#User의 메서드를 사용 public인 이유!
		remember_token = User.new_remember_token
		#cookies에 저장 옵션을 통해 기간도 조정가능
		#cookies[:remember_token] = { value:   remember_token,
        #                     expires: 20.years.from_now.utc }
		cookies.permanent[:remember_token] = remember_token
		user.update_attribute(:remember_token, User.encrypt(remember_token))
		self.current_user = user
	end

	def signed_in?
		#!는 bang이라고 읽는다.
		!current_user.nil?	
	end

	def current_user=(user)
		@current_user = user
	end

	def current_user
		remember_token = User.encrypt(cookies[:remember_token])
    	#||= 는 "or equals"
    	#@current_user가 undefine되어 있는 경우에만 설정된다. 
    @current_user ||= User.find_by(remember_token: remember_token)
  end

	def current_user?(user)
    user == current_user
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end
  	#current_user 를 비우고
  	#쿠키에 저장된 remember_token을 삭제한다.
  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def redirect_back_or(default)
  	redirect_to(session[:return_to] || default)
  	session.delete(:return_to)
  end

  	#session(Rails가 제공) 에 return_to라는 key로 request.url을 저장.
  	#url을 얻기 위해 request object를 사용할 수 있다.
  def store_location
  	session[:return_to] = request.url
  end
end
