require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  let!(:first_task) { FactoryBot.create(:task,created_at: '2022-02-18') }
  let!(:second_task) { FactoryBot.create(:second_task, created_at: '2022-02-17') }
  let!(:third_task) { FactoryBot.create(:third_task, created_at: '2022-02-16') }
    describe '登録機能' do
      context 'タスクを登録した場合' do
        it '登録したタスクが表示される' do
          visit new_task_path
          fill_in 'task[title]', with: 'first_task'
          fill_in 'task[content]', with: 'slum dunk'
          fill_in "終了期限", with: '002022-02-18T00:00'
          select '中', from:'task[priority]'
          select '未着手', from:'task[status]'
          click_on '登録する'
          expect(page).to have_content 'slum dunk'
        end
      end
    end


    describe '一覧表示機能' do
      let!(:first_task) { FactoryBot.create(:task,created_at: '2022-02-18') }
      let!(:second_task) { FactoryBot.create(:second_task, created_at: '2022-02-17') }
      let!(:third_task) { FactoryBot.create(:third_task, created_at: '2022-02-16') }
      context '一覧画面に遷移した場合' do
        it '作成済みのタスク一覧が作成日時の降順で表示される' do
          visit tasks_path
          expect(page).to have_content 'first_task'
          expect(page).to have_content  'second_task'
        end
      end
      context '新たにタスクを作成した場合' do
        it '新しいタスクが一番上に表示される' do
          visit tasks_path
          task_list = all('body tr')
          expect(task_list[1].text ).to have_content 'first_task_title'
        end
      end

      describe 'ソート機能' do
        context '「終了期限」というリンクをクリックした場合' do
          it "終了期限昇順に並び替えられたタスク一覧が表示される" do
            visit tasks_path
            click_link '終了期限'
            task_list = all('body tr')
            expect(task_list[1].text).to have_content 'one piece'

            # allメソッドを使って複数のテストデータの並び順を確認する
          end
        end
        context '「優先度」というリンクをクリックした場合' do
          it "優先度の高い順に並び替えられたタスク一覧が表示される" do
            visit tasks_path
            click_on '優先度'
            task_list = all('body tr')
            expect(task_list[1].text).to have_content 'haikyuu'
            # allメソッドを使って複数のテストデータの並び順を確認する
          end
        end
      end
      describe '検索機能' do
        context 'タイトルであいまい検索をした場合' do
          it "検索ワードを含むタスクのみ表示される" do
            expect(Task.title_like('first')).to include(first_task)
            expect(Task.title_like('first')).not_to include(second_task)
            expect(Task.title_like('first')).not_to include(third_task)
            expect(Task.title_like('first').count).to eq 1
            # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
          end
        end
        context 'ステータスで検索した場合' do
          it "検索したステータスに一致するタスクのみ表示される" do
            expect(Task.status_is('waiting')).to include(first_task)
            expect(Task.status_is('waiting')).not_to include(second_task)
            expect(Task.status_is('waiting')).not_to include(third_task)
            expect(Task.status_is('waiting').count).to eq 1
            # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
          end
        end
        context 'タイトルとステータスで検索した場合' do
          it "検索ワードをタイトルに含み、かつステータスに一致するタスクのみ表示される" do
            result_tasks = Task.title_like('first').status_is('waiting')
            expected_task = first_task
            expect(result_tasks).to include(first_task)
            expect(result_tasks).not_to include(second_task, third_task)
            expect(result_tasks.count).to eq 1
            # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
          end
        end
      end
    end


    describe '詳細表示機能' do
      context '任意のタスク詳細画面に遷移した場合' do
        it 'そのタスクの内容が表示される' do
          task = FactoryBot.create(:second_task)
          visit task_path(task)
          expect(page).to have_content 'haikyuu'
        end
      end
    end
end