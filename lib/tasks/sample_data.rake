namespace :db do 
	desc "Fill database with sample data"
	#Rake task가 local Rails environment에 접근하는 것을 보증. 
	task populate: :environment do
		#create!는 invalid user에 대해서 false를 리턴하기보다 exception을 발생.
		#debugging이 쉽다.
		User.create!(name: "Example User",
					  email: "example@railstutorial.org",
					  password: "foobar",
					  password_confirmation: "foobar",
					  admin: true)
		99.times do |n|
			name 	= Faker::Name.name
			email 	= "example-#{n+1}@railstutorial.org"
			password= "password"
			User.create!(name: name,
						 email: email,
						 password: password,
						 password_confirmation: password) 
		end

		#sample data를 생성하기 위해서 db:populate를 run해야 한다.
		users = User.all(limit: 6)
		50.times do
			#Faker::Lorem.setence는 lorem ipsum을 return한다.
			content = Faker::Lorem.sentence(5)
			users.each { |user| user.microposts.create!(content: content)}
		end
	end
end