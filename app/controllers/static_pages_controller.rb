class StaticPagesController < ApplicationController
  def home
  	if signed_in?
  	#조건을 걸어두면 예방할 수 있다! current_user가 nil일 경우
  	@micropost = current_user.microposts.build 
  	#feed를 앱내에서 사용하려면 instance variable을 만들어야 한다.
  	@feed_items = current_user.feed.paginate(page: params[:page])
  	end
  end

  def help
  end

  def about
  end

  def contact	
  end
end
