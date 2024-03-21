require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  describe '登録機能' do
    let!(:first_user) { FactoryBot.create(:first_user) }
    before do
      visit new_session_path
      fill_in('session_email', with: 'taro@g.com')
      fill_in('session_password', with: 'password')
      click_button('ログイン')
    end
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        visit new_task_path
        fill_in('task_title', with: 'first_task_title')
        fill_in('task_content', with: 'slum dunk')
        fill_in('task_deadline_on', with: "002022-2-18")
        select('middle', from: 'task_priority')
        select('waiting', from: 'task_status')
        click_button('登録する')
        task_list = all('body tbody tr')
        expect(page).to have_table
        expect(page).to have_text('タスクを登録しました')
        expect(task_list.first.text).to have_text('slum dunk')
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
    let!(:sabu_task) { third_user.tasks.create!(FactoryBot.build(:sabu_task).attributes) }

    before do
      visit new_session_path
      fill_in('session_email', with: 'taro@g.com')
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
        expect(task_list.last.text).not_to have_text('sabu_task')
      end
    end
    context '新たにタスクを作成した場合' do
      it '新しいタスクが一番上に表示される' do
        task_list = all('body tbody tr')
        expect(task_list.first.text).not_to have_text("latest")
        expect(task_list.first.text).to have_text("first_task")

        visit new_task_path
        fill_in('task_title', with: 'first_task_title')
        fill_in('task_content', with: 'slum dunk')
        fill_in('task_deadline_on', with: '002022-2-18')
        select('middle', from: 'task_priority')
        select('waiting', from: 'task_status')
        click_button('登録する')
        task_list_after_creating_task = all('body tbody tr')
        expect(page).to have_table
        expect(task_list_after_creating_task.first.text).to have_text("first_task_title")
        expect(task_list_after_creating_task[1].text).to have_text("slum dunk")
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
      fill_in('session_email', with: 'taro@g.com')
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
      fill_in('session_email', with: 'taro@g.com')
      fill_in('session_password', with: 'password')
      click_button('ログイン')
    end
    context 'タイトルであいまい検索をした場合' do
      it "検索ワードを含むタスクのみ表示される" do
        expect(page).to have_content('first_task')
        expect(page).to have_content('second_task')
        expect(page).to have_content('third_task')

        fill_in('search_title', with: 'first')
        click_button('検索')
        expect(page).to have_content('first_task')
        expect(page).not_to have_content('second_task')
        expect(page).not_to have_content('third_task')
      end
    end
    context 'ステータスで検索した場合' do
      it "検索したステータスに一致するタスクのみ表示される" do
        expect(page).to have_content('first_task')
        expect(page).to have_content('second_task')
        expect(page).to have_content('third_task')

        select('waiting', from: 'status_is')
        click_button('検索')
        expect(page).to have_content('first_task')
        expect(page).not_to have_content('second_task')
        expect(page).not_to have_content('third_task')

        select('working', from: 'status_is')
        click_button('検索')
        expect(page).not_to have_content('first_task')
        expect(page).to have_content('second_task')
        expect(page).not_to have_content('third_task')

        select('completed', from: 'status_is')
        click_button('検索')
        expect(page).not_to have_content('first_task')
        expect(page).not_to have_content('second_task')
        expect(page).to have_content('third_task')
        # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
      end
    end
    context 'タイトルとステータスで検索した場合' do
      it "検索ワードをタイトルに含み、かつステータスに一致するタスクのみ表示される" do
        expect(page).to have_content('first_task')
        expect(page).to have_content('second_task')
        expect(page).to have_content('third_task')

        select('waiting', from: 'status_is')
        fill_in('search_title', with: 'first')
        click_button('検索')
        expect(page).to have_content('first_task')
        expect(page).not_to have_content('second_task')
        expect(page).not_to have_content('third_task')

        select('working', from: 'status_is')
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
        fill_in('session_email', with: 'taro@g.com')
        fill_in('session_password', with: 'password')
        click_button('ログイン')
      end

      it 'そのタスクの内容が表示される' do
        visit task_path(first_task.id)
        expect(page).to have_text(first_task_title)
        expect(page).to have_text(slum dunk)

        expect(page).to have_text(first_task.priority)
        expect(page).to have_text(first_task.status)
        visit task_path(second_task.id)
        expect(page).to have_text(second_task_title)
        expect(page).to have_text('haikyuu')

        expect(page).to have_text(second_task.priority)
        expect(page).to have_text(second_task.status)
        visit task_path(third_task.id)
        expect(page).to have_text(third_task_title)
        expect(page).to have_text('one piece')

        expect(page).to have_text(third_task.priority)
        expect(page).to have_text(third_task.status)
      end
    end
  end
  describe '検索機能' do
    before do
      visit new_session_path
      fill_in('session_email', with: 'taro@g.com')
      fill_in('session_password', with: 'password')
      click_button('ログイン')
      visit _path
      fill_in('session_email', with: 'taro@g.com')
      fill_in('session_password', with: 'password')
      click_button('ログイン')
    end
    context 'ラベルで検索をした場合' do
      let!(:first_user) { FactoryBot.create(:first_user) }
      let!(:second_user) { FactoryBot.create(:second_user) }
      let!(:third_user) { FactoryBot.create(:third_user) }
      it "そのラベルの付いたタスクがすべて表示される" do
        task_list = all('body tbody tr')
        label = first_user.labels.build(name: 'ruby')
        expect(page).to have_table
        select('ruby', from: 'label_seach')
        click_button('検索')
        expect(page).to have_content('ruby')
        expect(page).not_to have_content('css')
        expect(page).not_to have_content('physon')
        # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
      end
    end
  end
end