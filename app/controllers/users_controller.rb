class UsersController < ApplicationController
  
  def show
  	@user = User.find(params[:id])
  end
  def new
  	#form_for는 @user가 필요하다. 그래서 간단히 만든다. 
  	@user = User.new
  end

  def create
  	#이상태로는 fail발생
  	#@user = User.new(params[:user]) #Not the final implementation!
  	@user = User.new(user_params)
  	if @user.save
  		#Handle a successful save
      flash[:success] = "Welcome to the Sample App!"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end

  private
  	def user_params
  		params.require(:user).permit(:name, :email, :password,
  									 :password_confirmation)
  	end

end
