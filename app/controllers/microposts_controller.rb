class MicropostsController < ApplicationController
	before_action :signed_in_user, only: [:create, :destroy]
	before_action :correct_user,   only: :destroy

	#
	def index
	end

	def create
		#build 메서드를 사용한게 특징!
		@micropost = current_user.microposts.build(micropost_params)
		if @micropost.save 
			flash[:success] = "Micropost created!"
			redirect_to root_url
		else
			@feed_items = []
			render 'static_pages/home'
		end
	end

	def destroy
		@micropost.destroy
		redirect_to root_url
	end

	private 

		def micropost_params
			params.require(:micropost).permit(:content)
		end

		def correct_user
			#microposts 인데 :id => params[:id] 형태로 검색? 
			#find_by_id(params[:id])
			#current_user에 속한것만 찾을 수 있다.
			#find를 쓴다면 micropost가 존재하지 않을 때 nil을 리턴하는 대신에 예외 발생.
			@micropost = current_user.microposts.find_by(id: params[:id])
			#micropost가 존재하지 않다면 root로! 삭제하기 전에 테스트;
			redirect_to root_url if @micropost.nil?
		end
		#예외다루는 것이 편하다면
		#def correct_user
		# @micropost = current_user.microposts.find(params[:id])
		#rescue
		# redirect_to root_url
		#end

		#Micropost를 찾고 그것의 유저가 current_user인지 비교
		#@micropost = Micropost.find_by(id: params[:id])
		#redirect_to root_url unless current_user?(@micropost.user)
		
end