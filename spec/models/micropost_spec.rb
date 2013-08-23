require 'spec_helper'

describe Micropost do
  let(:user) {FactoryGirl.create(:user)}
  
  before { @micropost = user.microposts.build(content: "Lorem ipsum")}
  #before do
  	#This code os not idiomatically correct
  #	@micropost = Micropost.new(content: "Lorem ipsum", user_id: user.id)
  #end

  subject { @micropost }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  #micropost의 user 가 위에서 local variable로 만든 user와 같은지 테스트!
  its(:user) { should eq user }

  #지금까지는 유효한 상황
  it { should be_valid }

  #지금부터 유효하지 않은 상항을 묘사
  describe "when user_id is not present" do 
  	#user_id가 존재하지 않는 상황을 미리 만든다.
  	before {@micropost.user_id = nil}
  	it { should_not be_valid } 
  end

  describe "with blank content" do
  	# 비어있으면 안돼!
  	before { @micropost.content =  " " }
  	it { should_not be_valid }
  end

  describe "with content that is too long" do
  	# 길이가 141 이상이면 안되는 걸 test하기 위해 설정!
  	before { @micropost.content = "a" * 141 }
  	it { should_not be_valid }
  end
end
