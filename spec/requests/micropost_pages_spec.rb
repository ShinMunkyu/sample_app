require 'spec_helper'
# sign-in한 상태에서 Micropost에 대한 테스트!
describe "MicropostPages" do

	subject { page }

	let(:user) { FactoryGirl.create(:user) }
	#먼저 signin이 선행되어야 합니다.
	before { sign_in user }

	describe "micropost creation" do
		#signin 후에 홈페이지로 이동 
		before{ visit root_path }

		describe "with invalid information" do
			
			it "should not create a micropost" do 
				#잘못된 정보를 입력했을때는 post버튼을 클릭해도 count가 변하지 않는다.
				expect { click_button "Post" }.not_to change(Micropost, :count)
			end

			describe "error messages" do
				before { click_button "Post" }
				it { should have_content('error')}
			end
		end

		describe "with valid information" do

			before { fill_in 'micropost_content', with: "Lorem ipsum" }
			it "should create a micropost" do
				expect { click_button "Post" }.to change(Micropost, :count).by(1)
			end
		end
	end

	describe "micropost destruction" do
		before { FactoryGirl.create(:micropost, user: user) }

		describe "as correnct user" do
			before { visit root_path }

			it "should delete a micropost" do
				expect { click_link "delete"}.to change(Micropost, :count).by(-1)
			end
		end
	end

end
