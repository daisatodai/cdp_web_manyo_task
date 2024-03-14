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

require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  describe '登録機能' do
    let!(:first_user) { FactoryBot.create(:first_user) }
    before do
      visit new_session_path
      fill_in('session_email', with: 'taro@sample.com')
      fill_in('session_password', with: 'password')
      click_button('ログイン')
    end
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        visit new_task_path
        fill_in('task_title', with: 'new task')
        fill_in('task_content', with: 'new task')
        fill_in('task_deadline_on', with: "2022-02-28")
        select('低', from: 'task_priority')
        select('未着手', from: 'task_status')
        click_button('登録する')
        task_list = all('body tbody tr')
        expect(page).to have_table
        expect(page).to have_text('タスクを登録しました')
        expect(task_list.first.text).to have_text('new task')
      end
    end
  end

  describe '一覧表示機能' do
    let!(:first_user) { FactoryBot.create(:first_user) }
    let!(:second_user) { FactoryBot.create(:second_user) }
    let!(:third_user) { FactoryBot.create(:third_user) }
    let!(:first_task) { first_user.tasks.create!(FactoryBot.build(:first_task).attributes) }
    let!(:second_task) { first_user.tasks.create!(FactoryBot.build(:second_task).attributes) }
    let!(:third_task) { first_user.tasks.create!(FactoryBot.build(:third_task).attributes) }
    let!(:jiro_task) { second_user.tasks.create!(FactoryBot.build(:jiro_task).attributes) }
    let!(:hanako_task) { third_user.tasks.create!(FactoryBot.build(:hanako_task).attributes) }

    before do
      visit new_session_path
      fill_in('session_email', with: 'taro@sample.com')
      fill_in('session_password', with: 'password')
      click_button('ログイン')
    end

    context '一覧画面に遷移した場合' do
      it '登録済みのタスク一覧が作成日時の降順で表示される' do
        task_list = all('body tbody tr')
        expect(page).to have_table
        expect(task_list.first.text).to have_text('first_task')
        expect(task_list.last.text).to have_text('third_task')
        expect(task_list.last.text).not_to have_text('jiro_task')
        expect(task_list.last.text).not_to have_text('hanako_task')
      end
    end
    context '新たにタスクを作成した場合' do
      it '新しいタスクが一番上に表示される' do
        task_list = all('body tbody tr')
        expect(task_list.first.text).not_to have_text("latest")
        expect(task_list.first.text).to have_text("first_task")

        visit new_task_path
        fill_in('task_title', with: 'latest')
        fill_in('task_content', with: 'latest task')
        fill_in('task_deadline_on', with: '2024-03-01')
        select('低', from: 'task_priority')
        select('未着手', from: 'task_status')
        click_button('登録する')
        task_list_after_creating_task = all('body tbody tr')
        expect(page).to have_table
        expect(task_list_after_creating_task.first.text).to have_text("latest")
        expect(task_list_after_creating_task[1].text).to have_text("first_task")
      end
    end
  end

  describe 'ソート機能' do
    let!(:first_user) { FactoryBot.create(:first_user) }
    let!(:first_task) { first_user.tasks.create!(FactoryBot.build(:first_task).attributes) }
    let!(:second_task) { first_user.tasks.create!(FactoryBot.build(:second_task).attributes) }
    let!(:third_task) { first_user.tasks.create!(FactoryBot.build(:third_task).attributes) }

    before do
      visit new_session_path
      fill_in('session_email', with: 'taro@sample.com')
      fill_in('session_password', with: 'password')
      click_button('ログイン')
    end

    context '「終了期限」というリンクをクリックした場合' do
      it "終了期限昇順に並び替えられたタスク一覧が表示される" do
        task_list_before_ordering = all('body tbody tr')
        expect(task_list_before_ordering[0].text).to have_text('first_task')
        expect(task_list_before_ordering[1].text).to have_text('second_task')
        expect(task_list_before_ordering[2].text).to have_text('third_task')
        click_link('終了期限')
        sleep(0.5)
        task_list_after_ordering = all('body tbody tr')
        expect(task_list_after_ordering[0].text).to have_text('third_task')
        expect(task_list_after_ordering[1].text).to have_text('second_task')
        expect(task_list_after_ordering[2].text).to have_text('first_task')
      end
    end
    context '「優先度」というリンクをクリックした場合' do
      it "優先度の高い順に並び替えられたタスク一覧が表示される" do
        task_list_before_ordering = all('body tbody tr')
        expect(task_list_before_ordering[0].text).to have_text('first_task')
        expect(task_list_before_ordering[1].text).to have_text('second_task')
        expect(task_list_before_ordering[2].text).to have_text('third_task')
        click_link('優先度')
        sleep(0.5)
        task_list_after_ordering = all('body tbody tr')
        expect(task_list_after_ordering[0].text).to have_text('second_task')
        expect(task_list_after_ordering[1].text).to have_text('first_task')
        expect(task_list_after_ordering[2].text).to have_text('third_task')
      end
    end
  end

  describe '検索機能' do
    let!(:first_user) { FactoryBot.create(:first_user) }
    let!(:first_task) { first_user.tasks.create!(FactoryBot.build(:first_task).attributes) }
    let!(:second_task) { first_user.tasks.create!(FactoryBot.build(:second_task).attributes) }
    let!(:third_task) { first_user.tasks.create!(FactoryBot.build(:third_task).attributes) }

    before do
      visit new_session_path
      fill_in('session_email', with: 'taro@sample.com')
      fill_in('session_password', with: 'password')
      click_button('ログイン')
    end
    context 'タイトルであいまい検索をした場合' do
      it "検索ワードを含むタスクのみ表示される" do
        task_list_before_search = all('body tbody tr')
        expect(task_list_before_search.count).to eq 3
        expect(page).to have_content('first_task')
        expect(page).to have_content('second_task')
        expect(page).to have_content('third_task')

        fill_in('search_title', with: 'first')
        click_button('検索')
        task_list_after_search = all('body tbody tr')
        expect(task_list_after_search.count).to eq 1
        expect(page).to have_content('first_task')
        expect(page).not_to have_content('second_task')
        expect(page).not_to have_content('third_task')
      end
    end
    context 'ステータスで検索した場合' do
      it "検索したステータスに一致するタスクのみ表示される" do
        task_list_before_search = all('body tbody tr')
        expect(task_list_before_search.count).to eq 3
        expect(page).to have_content('first_task')
        expect(page).to have_content('second_task')
        expect(page).to have_content('third_task')

        select('未着手', from: 'search_status')
        click_button('検索')
        task_list_after_search = all('body tbody tr')
        expect(task_list_after_search.count).to eq 1
        expect(page).to have_content('first_task')
        expect(page).not_to have_content('second_task')
        expect(page).not_to have_content('third_task')

        select('着手中', from: 'search_status')
        click_button('検索')
        task_list_after_search = all('body tbody tr')
        expect(task_list_after_search.count).to eq 1
        expect(page).not_to have_content('first_task')
        expect(page).to have_content('second_task')
        expect(page).not_to have_content('third_task')

        select('完了', from: 'search_status')
        click_button('検索')
        task_list_after_search = all('body tbody tr')
        expect(task_list_after_search.count).to eq 1
        expect(page).not_to have_content('first_task')
        expect(page).not_to have_content('second_task')
        expect(page).to have_content('third_task')
        # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
      end
    end
    context 'タイトルとステータスで検索した場合' do
      it "検索ワードをタイトルに含み、かつステータスに一致するタスクのみ表示される" do
        task_list_before_search = all('body tbody tr')
        expect(task_list_before_search.count).to eq 3
        expect(page).to have_content('first_task')
        expect(page).to have_content('second_task')
        expect(page).to have_content('third_task')

        select('未着手', from: 'search_status')
        fill_in('search_title', with: 'first')
        click_button('検索')
        task_list_after_search = all('body tbody tr')
        expect(task_list_after_search.count).to eq 1
        expect(page).to have_content('first_task')
        expect(page).not_to have_content('second_task')
        expect(page).not_to have_content('third_task')

        select('着手中', from: 'search_status')
        fill_in('search_title', with: 'first')
        click_button('検索')
        expect(page).not_to have_content('first_task')
        expect(page).not_to have_content('second_task')
        expect(page).not_to have_content('third_task')
      end
    end
  end

  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
      let!(:first_user) { FactoryBot.create(:first_user) }
      let!(:first_task) { first_user.tasks.create!(FactoryBot.build(:first_task).attributes) }
      let!(:second_task) { first_user.tasks.create!(FactoryBot.build(:second_task).attributes) }
      let!(:third_task) { first_user.tasks.create!(FactoryBot.build(:third_task).attributes) }

      before do
        visit new_session_path
        fill_in('session_email', with: 'taro@sample.com')
        fill_in('session_password', with: 'password')
        click_button('ログイン')
      end

      it 'そのタスクの内容が表示される' do
        visit task_path(first_task.id)
        expect(page).to have_text(first_task.title)
        expect(page).to have_text(first_task.content)
        expect(page).to have_text(first_task.created_at.strftime("%Y/%m/%d %H:%M"))
        expect(page).to have_text(first_task.deadline_on.strftime("%Y/%m/%d"))
        expect(page).to have_text(first_task.priority)
        expect(page).to have_text(first_task.status)
        visit task_path(second_task.id)
        expect(page).to have_text(second_task.title)
        expect(page).to have_text(second_task.content)
        expect(page).to have_text(second_task.created_at.strftime("%Y/%m/%d %H:%M"))
        expect(page).to have_text(second_task.deadline_on.strftime("%Y/%m/%d"))
        expect(page).to have_text(second_task.priority)
        expect(page).to have_text(second_task.status)
        visit task_path(third_task.id)
        expect(page).to have_text(third_task.title)
        expect(page).to have_text(third_task.content)
        expect(page).to have_text(third_task.created_at.strftime("%Y/%m/%d %H:%M"))
        expect(page).to have_text(third_task.deadline_on.strftime("%Y/%m/%d"))
        expect(page).to have_text(third_task.priority)
        expect(page).to have_text(third_task.status)
      end
    end
  end
end