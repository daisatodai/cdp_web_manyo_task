# 「FactoryBotを使用します」という記述
FactoryBot.define do
  # 作成するテストデータの名前を「task」とします
  # 「task」のように存在するクラス名のスネークケースをテストデータ名とする場合、そのクラスのテストデータが作成されます
  factory :first_task , class: Task do
    title { 'first_task_title' }
    content { 'slum dunk'}
    deadline_on { '002022-2-18'}
    created_at {'2022-02-16'}
    priority { 'middle' }
    status { 'waiting' }
  end
  # 作成するテストデータの名前を「second_task」とします
  # 「second_task」のように存在しないクラス名のスネークケースをテストデータ名とする場合、`class`オプションを使ってどのクラスのテストデータを作成するかを明示する必要があります
  factory :second_task , class: Task do
    title { 'second_task_title' }
    content {'haikyuu' }
    deadline_on {'002022-2-17'}
    created_at {'2022-02-16'}
    priority { 'high' }
    status { 'working' }
  end

  factory :third_task , class: Task do
    title { 'third_task_title' }
    content { 'one piece' }
    deadline_on {'002022-2-16'}
    created_at {'2022-02-16'}
    priority { 'low' }
    status { 'completed' }
  end
end