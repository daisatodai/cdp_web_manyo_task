# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# if User.find_by(email: "sample10@g.com")
#   admin_user = User.find_by(email: "sample10@g.com")
# else
#   admin_user = User.create(
#     name: "管理者２", 
#     email: "sample10@g.com",
#     password: "password",
#     admin: true
#   )
# end

# 1.times do |n|
#   admin_user.tasks.create(
#     title: "タスク #{n + 1}",
#     content: "任意",
#     deadline_on: Date.new(2022, 8, n + 1),
#     priority: rand(0..2),
#     status: rand(0..2)
#   )
# end


  not_admin_user = User.create(
  name: "",
  email: "sample88@g.com",
  password: "password",
  admin: false
)

50.times do |n|
  not_admin_user.tasks.create(
    title: "ToDo #{n + 1}",
    content: "任意",
    deadline_on: Date.new(2022, 12, n + 1),
    priority: rand(0..2),
    status: rand(0..2)
  )
end



# 10.times do |i|
#   n = i+1
# Task.create!(
#   title: "Task.title#{i+1}",
#   content: "任意",
#   deadline_on: Date.new(2022, 8, n),
#   priority: rand(0..2) ,
#   status: rand(0..2) )
# end