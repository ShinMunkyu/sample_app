class UsersController < ApplicationController
  #signed_in_user라는 메서드 에 :edit, :update, :index 액션...
  #액션이 실행되 전에 호출되는 메서드;
  #only는 option이다. hash형태로 작성
  #action목록은 array로 !
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    #데이터베이스에 있는 자료 모두 가져와 instance variable에 할당한다. 
    #@users = User.all
    #paginate
    @users = User.paginate(page: params[:page])
  end

  def show
  	@user = User.find(params[:id])
    #index의 user와 같은 구조.
    #test한 것중 show html에 서 content보여줄 때 에러생김. 
    @microposts = @user.microposts.paginate(page: params[:page])
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
      #sessions_helper 모듈안에 있는 메서드
      sign_in @user
  		#Handle a successful save
      flash[:success] = "Welcome to the Sample App!"
      #profile 화면으로 /users/1
  		redirect_to @user
  	else
  		render 'new'
  	end
  end

  # 수정화면으로 가기위해서는 기존의 user정보가 필요하다.
  def edit 
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    #string parameters를 쓰는 이유는 mass assignment vulnerability를 예방하기 위해서
    if @user.update_attributes(user_params)
      #Handle a successful update
      #create랑 로직이 같다. 
      #user가 save될 때 remember_token이 갱신되므로
      #다시 sign in 을 해준다.
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      #메서드 호출; 
      #edit 화면으로 이동하려고
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end
  private
  	def user_params
  		params.require(:user).permit(:name, :email, :password,
  									 :password_confirmation)
  	end

    #Before filters

    #module helper로 이동
    #def signed_in_user
      #unless signed_in? 
        #store_location
          #signin_url은 어디서 정의했는지, signni_path 는 안되는지?
          #flash[:notice]라고 적는게 원래 문법이지만
          #redirect_to function을 활용해 shortcut으로 적을 수 있다.
          #redirect_to signin_url , notice: "Please sign in."
        
        #unless signed_in?
        #  flash[:notice] = "Please sign in."
        #  redirect_to signin_url
        #end
        
      #end
    #end

    def correct_user
      #current_user와 path에 포함된 id의 user가
      #같은지 비교하고 아니라면 root_url로 redirct
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
