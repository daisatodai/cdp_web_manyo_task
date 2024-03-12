# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(
  name: "管理者２", 
  email: "sample@g.com",
  password: "password",
  admin: true
)

# 10.times do |i|
#   n = i+1
# Task.create!(
#   title: "Task.title#{i+1}",
#   content: "任意",
#   deadline_on: Date.new(2022, 8, n),
#   priority: rand(0..2) ,
#   status: rand(0..2) )
# end