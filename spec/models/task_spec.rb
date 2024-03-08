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
      let!(:first_task) { FactoryBot.create(:task) }
      let!(:second_task) { FactoryBot.create(:second_task) }
      let!(:third_task) { FactoryBot.create(:third_task) }
      context 'scopeメソッドでタイトルのあいまい検索をした場合' do
        it "検索ワードを含むタスクが絞り込まれる" do
          expect(Task.title_like('first')).to include(first_task)
          expect(Task.title_like('first')).not_to include(second_task)
          expect(Task.title_like('first')).not_to include(third_task)
          expect(Task.title_like('first').count).to eq 1
        end
      end
      context 'scopeメソッドでステータス検索をした場合' do
        it "ステータスに完全一致するタスクが絞り込まれる" do
          expect(Task.status_is('waiting')).to include(first_task)
          expect(Task.status_is('waiting')).not_to include(second_task)
          expect(Task.status_is('waiting')).not_to include(third_task)
          expect(Task.status_is('waiting').count).to eq 1
          # toとnot_toのマッチャを使って検索されたものとされなかったものの両方を確認する
          # 検索されたテストデータの数を確認する
        end
      end
      context 'scopeメソッドでタイトルのあいまい検索とステータス検索をした場合' do
        it "検索ワードをタイトルに含み、かつステータスに完全一致するタスクが絞り込まれる" do
          result_tasks = Task.title_like('first').status_is('waiting')
          expected_task = first_task
          expect(result_tasks).to include(first_task)
          expect(result_tasks).not_to include(second_task, third_task)
          expect(result_tasks.count).to eq 1
        end
      end
    end
end

