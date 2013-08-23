class Micropost < ActiveRecord::Base
	#user에 포함된 관계인지 명시.
	belongs_to :user
	#ordering test를 통과하기위해 
	#Rails 기능 중에 default_scope(order가 argument)를 사용
	default_scope -> { order('created_at DESC') }
	#content에 대한 validates 
	validates :content, presence: true, length: { maximum: 140 }
	#user_id에 대한 validates 
	validates :user_id, presence: true
end
