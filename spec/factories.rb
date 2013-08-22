FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}"}
    sequence(:email) { |n| "Person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
    	#이제 FactoryGirl.create(:admin)을 
    	#test에서 관리자 생성할 때 사용할 수 있다.
    	admin true
    end
  end
end