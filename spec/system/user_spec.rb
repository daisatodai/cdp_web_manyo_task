require 'rails_helper'

RSpec.describe 'ユーザ管理機能', type: :system do
  describe '登録機能' do
    before do
      visit new_user_path
    end
    context 'ユーザを登録した場合' do
      it 'タスク一覧画面に遷移する' do
        fill_in('user_name', with: 'taro')
        fill_in('user_email', with: 'taro@g.com')
        fill_in('user_password', with: 'password')
        fill_in('user_password_confirmation', with: 'password')
        click_button('登録する')
        expect(page).to have_table
        expect(page).to have_content('タスク一覧ページ')
      end
    end
    context 'ログインせずにタスク一覧画面に遷移した場合' do
      it 'ログイン画面に遷移し、「ログインしてください」というメッセージが表示される' do
        visit tasks_path
        expect(page).to have_content('ログインページ')
        expect(page).to have_content('ログインしてください')
      end
    end
  end

  describe 'ログイン機能' do
    context '登録済みのユーザでログインした場合' do
      let!(:first_user) { FactoryBot.create(:first_user) }
      let!(:second_user) { FactoryBot.create(:second_user) }
      before do
        visit new_session_path
        fill_in('session_email', with: 'taro@g.com')
        fill_in('session_password', with: 'password')
        click_button('ログイン')
      end
      it 'タスク一覧画面に遷移し、「ログインしました」というメッセージが表示される' do
        expect(page).to have_text('タスク一覧ページ')
        expect(page).to have_text('ログインしました')
      end
      it '自分の詳細画面にアクセスできる' do
        click_link('アカウント設定')
        expect(page).to have_text('アカウント詳細ページ')
        expect(page).to have_text(first_user.name)
        expect(page).to have_text(first_user.email)
      end
      it '他人の詳細画面にアクセスすると、タスク一覧画面に遷移する' do
        visit user_path(second_user.id)
        expect(page).to have_text('タスク一覧ページ')
        expect(page).to have_text('アクセス権限がありません')
      end
      it 'ログアウトするとログイン画面に遷移し、「ログアウトしました」というメッセージが表示される' do
        click_link('ログアウト')
        expect(page).to have_text('ログインページ')
        expect(page).to have_text('ログアウトしました')
      end
    end
  end

  describe '管理者機能' do
    context '管理者がログインした場合' do
      let!(:first_user) { FactoryBot.create(:first_user) }
      let!(:second_user) { FactoryBot.create(:second_user) }
      let!(:third_user) { FactoryBot.create(:third_user) }
      before do
        visit new_session_path
        fill_in('session_email', with: 'saburo@g.com')
        fill_in('session_password', with: 'password')
        click_button('ログイン')
      end
      it 'ユーザ一覧画面にアクセスできる' do
        visit tasks_path
        click_link('ユーザ一覧')
        expect(page).to have_text('ユーザ一覧ページ')
        expect(page).to have_table
      end
      it '管理者を登録できる' do
        visit tasks_path
        expect(page).to have_text('ユーザを登録する')
        click_link('ユーザを登録する')
        expect(page).to have_text('ユーザ登録ページ')
        fill_in('user_name', with: 'taro' )
        fill_in('user_email', with: 'samplesample@g.com')
        fill_in('user_password', with: 'password')
        fill_in('user_password_confirmation', with: 'password')
        check('user[admin]')
        click_button('登録する')
        expect(page).to have_text('ユーザを登録しました')
        expect(page).to have_text('samplesample@g.com')
      end

       it 'ユーザ詳細画面にアクセスできる' do
        visit admin_user_path(second_user.id)
        expect(page).to have_text('ユーザ詳細ページ')
        expect(page).to have_text('jiro@g.com')
        expect(page).to have_table
        expect(page).to have_text('タイトル')
        expect(page).to have_text('内容')
        expect(page).to have_text('終了期限')
        expect(page).to have_text('優先度')
        expect(page).to have_text('ステータス')
      end
      it 'ユーザ編集画面から、自分以外のユーザを編集できる' do
        visit edit_admin_user_path(third_user.id)
        expect(page).to have_text('ユーザ編集ページ')
        fill_in('user_name', with: 'sabu_admin')
        fill_in('user_email', with: 'saburo@g.com')
        fill_in('user_password', with: 'password')
        fill_in('user_password_confirmation', with: 'password')
        click_button('更新する')
        expect(page).to have_text('ユーザ一覧ページ')
        expect(page).to have_text('ユーザを更新しました')
        expect(page).to have_text('jiro@g.com')
      end
      it 'ユーザを削除できる' do
        click_link('ユーザ一覧')
        expect(page).to have_text('saburo@g.com')
        delete_user_id = User.find_by(name: 'jiro').id
        accept_alert do
          click_link('削除',href: "/admin/users/#{delete_user_id}")
        end
        expect(page).to have_text('ユーザ一覧ページ')
        expect(page).to have_text('ユーザを削除しました')
        expect(page).not_to have_text('jiro@g.com')
      end
    end
    context '一般ユーザがユーザ一覧画面にアクセスした場合' do
      let!(:first_user) { FactoryBot.create(:first_user) }
      let!(:second_user) { FactoryBot.create(:second_user) }
      before do
        visit new_session_path
        fill_in('session_email', with: 'jiro@g.com')
        fill_in('session_password', with: 'password')
        click_button('ログイン')
      end
      it 'タスク一覧画面に遷移し、「管理者以外アクセスできません」というエラーメッセージが表示される' do
        expect(page).not_to have_text('ユーザ一覧')
        expect(page).not_to have_text('ユーザを登録する')
        visit admin_users_path
        expect(page).to have_text('管理者以外アクセスできません')
        expect(page).to have_text('タスク一覧ページ')
      end
    end
  end
end

