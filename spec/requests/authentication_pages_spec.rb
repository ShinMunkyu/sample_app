require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_title('Sign in') }
      #코드의 의미는 error_message를 만났다는 의미 새로 변경해보자.
      #utilities.rb에 have_error_message를 정의
      #it { should have_selector('div.alert.alert-error', text: 'Invalid') }
      it { should have_error_message('Invalid') }

      # 다른 페이지로 이동했을 때 alert-error창이 사라지도록!
      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      #utilities.rb에 sign_in를 정의
      before { sign_in user }

      it { should have_title(user.name) }
      it { should have_link('Users',       href: users_path) }
      it { should have_link('Profile',     href: user_path(user)) }
      it { should have_link('Settings',    href: edit_user_path(user))}
      it { should have_link('Sign out',    href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }

      #signout test
      #We'll click on the "Sign out" link
      #and then look for the reappearance of the signin link
      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
    end
  end

  describe "authorization" do 

    #friendly forwarding
    #처음 edit페이지 방문했을 때 signin page
    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "after signing in" do
        # 로그인이 완료되고? 
          it "should render the desired protected page" do
            expect(page).to have_title('Edit user')
          end
        end
      end

      describe "in the Microposts controller" do

        describe "submitting to the create action" do
          #path앞에는 request이름을 적는다.
          #visit은 단순한 get
          before { post microposts_path }
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe "submitting to the destroy action" do
          #create의 arguments는 factories.rb에 설정한 factory
          #micropost_path는 route에서 지정한 resource 이름
          #destroy는 하나니깐 단수형으로!
          before { delete micropost_path(FactoryGirl.create(:micropost)) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end

      describe "in the Users Controller" do 

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title('Sign in')}
        end

        describe "submitting to the update action" do
          #patch request /users/1 과 연결
          #update action과 연결 
          #브라우저에서는 edit을 거쳐서 간접적으로 접근해야 한다.
          #결론적으로 update action을 인증하는 것을 테스트 하는 방법은 직접 요청하는 것이다.
          before { patch user_path(user)}
          #HTTP request를 직접 다루는 방법을 사용할 때 
          #low-level response object에 접근할 수 있다.
          #page object와 다르게 response는 서버 반응을 테스트할 수 있게 한다.
          #여기에서는 signin page를 redirecting함으로써 반응을 검증한다.
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_title('Sign in') }
        end
      end
    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user, no_capybara: true }

      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_title(full_title('Edit user')) }
      end

      describe "submitting a PATCH request to the Users#update action" do
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end

    describe "as non-admin user" do
      let(:user) {FactoryGirl.create(:user)}
      let(:non_admin) {FactoryGirl.create(:user)}

      before {sign_in non_admin, no_capybara: true}

      describe "submitting a DELETE request to the Users#destroy action" do
        before {delete user_path(user)}
        specify { expect(response).to redirect_to(root_url)}
      end
    end
  end
end

