# 「FactoryBotを使用します」という記述
FactoryBot.define do
  # 作成するテストデータの名前を「task」とします
  # 「task」のように存在するクラス名のスネークケースをテストデータ名とする場合、そのクラスのテストデータが作成されます
  factory :task do
    title { 'first_task' }
    created_at { '2022-02-18' }
  end
  # 作成するテストデータの名前を「second_task」とします
  # 「second_task」のように存在しないクラス名のスネークケースをテストデータ名とする場合、`class`オプションを使ってどのクラスのテストデータを作成するかを明示する必要があります
  factory :second_task, class: Task do
    title { 'second_task' }
    content {'baseball' }
    created_at { '2022-02-17' }
  end

  factory :third_task, class: Task do
    title { 'third_task' }
    content { 'soccer' }
    created_at { '2022-02-16' }
  end
end