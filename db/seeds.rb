require 'faker'

user = User.create(email: 'usertest@example.com', password: 123456)

3.times do
  book = Book.create(name: Faker::Lorem.word, user:user)
  4.times do
    Note.create(name:Faker::Lorem.word, content: Faker::Markdown.random, book: book ) 
  end
end
