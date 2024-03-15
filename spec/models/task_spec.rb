require 'rails_helper'

RSpec.describe 'タスクモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    context 'タスクのタイトルが空文字の場合' do
      it 'バリデーションに失敗する' do
        task = Task.create(title: '', content: '企画書を作成する。')
        expect(task).not_to be_valid
      end
    end
  end

    context 'タスクの説明が空文字の場合' do
      it 'バリデーションに失敗する' do
        task = Task.create(title: 'text', content: '')
        expect(task).not_to be_valid
      end
    end

    context 'タスクのタイトルと説明に値が入っている場合' do
      it 'タスクを登録できる' do
        task = Task.create(title: 'text', content: '企画書を作成する。', )
        expect(task).to be_invalid
      end
    end

  describe '検索機能' do
    let!(:first_user) { FactoryBot.create(:first_user) }
    let!(:first_task) { first_user.tasks.create!(FactoryBot.build(:first_task).attributes) }
    let!(:second_task) { first_user.tasks.create!(FactoryBot.build(:second_task).attributes) }
    let!(:third_task) { first_user.tasks.create!(FactoryBot.build(:third_task).attributes) }
    context 'scopeメソッドでタイトルのあいまい検索をした場合' do
      it "検索ワードを含むタスクが絞り込まれる" do
        tasks = Task.title_like('first')
        expect(tasks).to include(first_task)
        expect(tasks).not_to include(second_task)
        expect(tasks).not_to include(third_task)
        expect(tasks.count).to eq 1

        tasks = Task.title_like('second')
        expect(tasks).not_to include(first_task)
        expect(tasks).to include(second_task)
        expect(tasks).not_to include(third_task)
        expect(tasks.count).to eq 1

        tasks = Task.title_like('third')
        expect(tasks).not_to include(first_task)
        expect(tasks).not_to include(second_task)
        expect(tasks).to include(third_task)
        expect(tasks.count).to eq 1

        tasks = Task.title_like('task')
        expect(tasks).to include(first_task)
        expect(tasks).to include(second_task)
        expect(tasks).to include(third_task)
        expect(tasks.count).to eq 3
        # toとnot_toのマッチャを使って検索されたものとされなかったものの両方を確認する
        # 検索されたテストデータの数を確認する
      end
    end
    context 'scopeメソッドでステータス検索をした場合' do
      it "ステータスに完全一致するタスクが絞り込まれる" do
        tasks = Task.status_is(0)
        expect(tasks).not_to include(second_task)
        expect(tasks).not_to include(third_task)

        tasks = Task.status_is(1)
        expect(tasks).not_to include(first_task)
        expect(tasks).to include(second_task)
        expect(tasks).not_to include(third_task)

        tasks = Task.status_is(2)
        expect(tasks).not_to include(first_task)
        expect(tasks).not_to include(second_task)
        expect(tasks).to include(third_task)
        # toとnot_toのマッチャを使って検索されたものとされなかったものの両方を確認する
        # 検索されたテストデータの数を確認する
      end
    end
    context 'scopeメソッドでタイトルのあいまい検索とステータス検索をした場合' do
      it "検索ワードをタイトルに含み、かつステータスに完全一致するタスクが絞り込まれる" do
        tasks = Task.search_title_status('second', 1)
        expect(tasks).to include(second_task)
        expect(tasks).not_to include(third_task)

        tasks = Task.search_title_status('third', 2)
        expect(tasks).not_to include(second_task)
        expect(tasks).to include(third_task)
      end
    end
  end
end