require 'spec_helper'

describe User do
  before do
   @user = User.new(name: "Example User", email: "user@example.com",
                            password: "foobar", password_confirmation: "foobar") 
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest)}
  it { should respond_to(:password)}
  it { should respond_to(:password_confirmation)}
  it { should respond_to(:remember_token)}
  it { should respond_to(:authenticate)}
  it { should respond_to(:admin)}

  it { should be_valid }
  it { should_not be_admin }

  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end
  
  #password, password_confirmation presence test!
  describe "when password is not present" do
  before do
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: " ", password_confirmation: " ")
  end
  it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  #안 되는 형식을 미리 넣어 두
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  #되는 형식
  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  #이메일 중복시에 거절하기용 테스
  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  #password와 password_confirmation이 일치하지 않을때!
  describe "when password doesn't match confirmation" do
  before { @user.password_confirmation = "mismatch" }
  it { should_not be_valid }
  end

  #비밀번호호 인증!
  describe "return value of authenticate method" do
  #let메서드로 되찾아오기 위하여 미리 database에 저장
  before { @user.save }
  #let메서드는 test안에 local variable을 만드는 편리한 방법이다. 
  #symbol로 된 argument에는 block의 return value가 담긴다.
  #let의 장점은 여기서는 find_by의 결과를 한번만 call하고 
  #User model specs가 돌아가는 도중에는 언제든지 사용가능하다.
  let(:found_user) { User.find_by(email: @user.email) }

  #아래 두개의 describe는 @user와 found_user가 같은지 다른지를 다룬다. 
  #eq(객체의 동등성 비교) test를 사용해서! 
  describe "with valid password" do
    it { should eq found_user.authenticate(@user.password) }
  end

  describe "with invalid password" do
    #앞서 사용한 let을 통해 found_user의 정보를 이용할 때 
    #다시 database에서 값을 되찾아오지 않아도 된다.
    let(:user_for_invalid_password) { found_user.authenticate("invalid") }

    it { should_not eq user_for_invalid_password }
    #specify는 it의 동의어이다.   it이 문맥상 자연스럽지 않을때 사용한다.
    specify { expect(user_for_invalid_password).to be_false }
  end
  end

  #비밀번호 자리수 제한 최소한 6자리!
  describe "with a password that's too short" do
  before { @user.password = @user.password_confirmation = "a" * 5 }
  it { should be_invalid }
  end

  #remember_token 테스트 
  describe "remember token" do
    #먼저 저장해야 한다.
    before { @user.save }
    #it은 subject로 지정한것에 대한 test
    #its는 다음 attribute(여기서는 remember_token)에 대한 test 
    its(:remember_token) { should_not be_blank }
  end
end
