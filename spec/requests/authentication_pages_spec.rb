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
      #utilities.rb에 valid_signin를 정의
      before { valid_signin(user) }

      it { should have_title(user.name) }
      it { should have_link('Profile',     href: user_path(user)) }
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
end

