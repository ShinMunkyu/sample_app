require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "index" do
    #before do
    #  sign_in FactoryGirl.create(:user)
    #  FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
    #  FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
    #  visit users_path
    #end

    #it { should have_title('All users') }
    #it { should have_content('All users')}

    #it "should list each user" do
      #User.all은 database에 있는거 모두 가져온다.
      #그리고 instance variable @user에 할당한다.
    #  User.all.each do |user|
    #    expect(page).to have_selector('li', text: user.name)
    #  end
    #end

    #pagination적용 
    let(:user) { FactoryGirl.create(:user) }
    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_title('All users') }
    it { should have_content('All users') }

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end

    describe "delete links" do

      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end

  describe "profile page" do
  	let(:user) { FactoryGirl.create(:user) }
    #user와 관계를 설정한 micropost를 생성한다.
    let!(:m1) { FactoryGirl.create( :micropost, user: user, content: "Foo") }
    let!(:m2) { FactoryGirl.create( :micropost, user: user, content: "Bar") }

  	before { visit user_path(user) }

 	  it { should have_content(user.name) }
  	it { should have_title(user.name) }

    describe "microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      #association에서 count method를 사용하는 것은 좋다. 
      #count는 database에 직접적으로 영향을 미친다.
      it { should have_content(user.microposts.count) }
    end
  end

  describe "signup page" do
    before { visit signup_path }

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }
  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_link('Sign out') }
        it { should have_title(user.name) }
        #have_selector는 특정 태그와 같이 쓰는 CSS class 선택 메서드이다. 
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end
    end
  end

  #edit페이제에 대한 test
  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do 
      #visit edit_user_path(user)는 signed-in user를 요구하기 때문에 
      #코드를 추가해야 한다.
      sign_in user
      visit edit_user_path(user) 
    end

    describe "page" do
      it { should have_content("Update your profile") }
      it { should have_title("Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    #Test for the user update action
    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      #reload하면 변경된 결과를 test에도 반영!
      #==과 eq는 같은의미?? 여기서는 error발생 
      specify { expect(user.reload.name).to  eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end
  end
end
