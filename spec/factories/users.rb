FactoryBot.define do
  factory :first_user, class: User do
    name  { 'taro' }
    email { 'taro@g.com' }
    password { 'password' }
    password_confirmation { 'password'  }
    admin { false }

    trait :with_tasks do
      after(:create) do |user|
        user.tasks.create!(FactoryBot.build(:first_task).attributes)
      end
    end
  end

  factory :second_user , class: User do
    name { 'jiro' }
    email { 'jiro@g.com' }
    password { 'password' }
    password_confirmation { 'password'  }
    admin { false }

    trait :with_tasks do
      after(:create) do |user|
        user.tasks.create!(FactoryBot.build(:second_task).attributes)
      end
    end
  end

  factory :third_user, class: User do
    name { "sabu" }
    email { "saburo@g.com" }
    password { 'password' }
    password_confirmation { 'password'  }
    admin { true }

    trait :with_tasks do
      after(:create) do |user|
        user.tasks.create!(FactoryBot.build(:third_task).attributes)
      end
    end
  end
end