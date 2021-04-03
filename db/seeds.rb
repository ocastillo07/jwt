# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#cleanup first
Author.delete_all
Post.delete_all

#populating the tables
(1..10).each do
  post = Post.create(title: Faker::Book.title, body: Faker::Lorem.paragraph, published: Faker::Boolean.boolean)
  post.authors.create(name: Faker::Book.author, email: Faker::Internet.email, score: Faker::Number.between(from: 1, to: 10) )
  post.authors.create(name: Faker::Book.author, email: Faker::Internet.email, score: Faker::Number.between(from: 1, to: 10) )
  post.authors.create(name: Faker::Book.author, email: Faker::Internet.email, score: Faker::Number.between(from: 1, to: 10) )
  post.authors.create(name: Faker::Book.author, email: Faker::Internet.email, score: Faker::Number.between(from: 1, to: 10) )
end