require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  describe '登録機能' do
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        visit new_task_path
        fill_in 'task[title]', with: 'slum_dunk'
        fill_in 'task[content]', with: 'first_task'
        click_on 'Create Task'
        expect(page).to have_content 'first_task'
      end
    end
  end

  describe '一覧表示機能' do
    let!(:task) { FactoryBot.create(:task, title: 'first_task', content: 'slum_dunk', created_at: '2022-02-18') }
    before do
      FactoryBot.create(:second_task)
      FactoryBot.create(:third_task)
      visit tasks_path
    end
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が作成日時の降順で表示される' do
        expect(page).to have_content '2022-02-17'
        expect(page).to have_content '2022-02-16'
      end
    end
    context '新たにタスクを作成した場合' do
      it '新しいタスクが一番上に表示される' do
        task_list = all('body tr')
        expect(task_list[1].text ).to have_content 'slum_dunk'
      end
    end
  end

  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
      it 'そのタスクの内容が表示される' do
        task = FactoryBot.create(:second_task)
        visit task_path(task)
        expect(page).to have_content 'baseball'
      end
    end
  end
end