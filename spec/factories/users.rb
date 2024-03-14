FactoryBot.define do
  factory :user, class: User do
    name  { 'taro' }
    email { 'sample@g.com' }
    password { 'password' }
    password_confirmation { 'password'  }
    admin { false }
  end

  factory :second_user , class: User do
    name { 'jiro' }
    email { 'sample2@g.com' }
    password { 'password' }
    password_confirmation { 'password'  }
    admin { false }
  end

  factory :third_user, class: User do
    name { "sabu" }
    email { "sample3@g.com" }
    password { 'password' }
    password_confirmation { 'password'  }
    admin { true }
  end
end
