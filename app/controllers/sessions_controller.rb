class SessionsController < ApplicationController

	def new 
	end

	def create
		#이메일에 해당하는 유저를 db에서 가져와서 
		#그 유저가 존재하는지랑, 유저의 패스워드가 맞는지를 동시에 체크!
		# nil && [anything] == false
		# true && false(wrong password) == false
		# true && true(right password) == true
		user = User.find_by(email: params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			#Sign the user in and redirect to the user's show page
			sign_in user
			
			#friendly forwarding을 적용하기 위해 변경!
			#redirect_to user
			redirect_back_or user
		else
			#Create an error message and re-render the signin form
			#flash대신에 flash.now를 사용 
			flash.now[:error] = 'Invalid email/password combination'
			render 'new'
		end	
	end

	def destroy
		sign_out
		redirect_to root_url
	end
end
