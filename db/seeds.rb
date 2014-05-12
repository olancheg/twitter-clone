names = %w(John Adam Alan Matt Kevin)
surnames = %w(Storm Sand Winter Wind Summer)

users = 25.times.map do |i|
  user = User.new.tap do |user|
    user.email = "test#{i}@mail.com"
    user.username = "user#{i}"
    user.realname = "#{names.sample} #{surnames.sample}"
    user.password = user.password_confirmation = 'testetest'
    user.save!
  end
  rand(10).times do
    user.tweets.create(body: 'Lorem ipsum ' * (rand(10) + 1))
  end
  user
end

Tweet.find_each do |tweet|
  rand(10).times do |i|
    tweet.add_comment({ body: "Comment ##{i}" }, users.sample)
  end
end
