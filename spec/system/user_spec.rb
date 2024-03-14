require 'rails_helper'

  RSpec.describe 'ユーザ管理機能', type: :system do
    let!(:third_user) { FactoryBot.create(:third_user) }
    let!(:user) { FactoryBot.create(:user) }
    let!(:task) { FactoryBot.create(:task, user: user) }
    let!(:second_user) { FactoryBot.create(:second_user) }
    describe '登録機能' do
      context 'ユーザを登録した場合' do
        it 'タスク一覧画面に遷移する' do
          visit new_user_path
          fill_in 'user[name]', with: 'taro'
          fill_in 'user[email]', with: 'sample@g.com'
          fill_in 'user[password]', with: 'password'
          fill_in 'user[password_confirmation]', with: 'password'
          click_button ('登録する')
          visit tasks_path
          expect(response.body).to include("アカウントを登録しました")
        end
      end
      context 'ログインせずにタスク一覧画面に遷移した場合' do
        it 'ログイン画面に遷移し、「ログインしてください」というメッセージが表示される' do
          cookies.delete(:user_id)
          get tasks_path
          expect(response).to redirect_to(login_path)
          expect(response.body).to include("ログインしてください")
        end
      end
    end

    describe 'ログイン機能' do
      context '登録済みのユーザでログインした場合' do
          it 'タスク一覧画面に遷移し、「ログインしました」というメッセージが表示される' do
            visit new_session_path
            fill_in 'user[email]', with: 'sample3@g.com'
            fill_in 'user[password]', with: 'password'
            click_button ('ログイン')
            expect(response.body).to include("ログインしました")
          end

        it '自分の詳細画面にアクセスできる' do
            visit new_session_path
            fill_in 'user[email]', with: 'sample3@g.com'
            fill_in 'user[password]', with: 'password'
            click_button ('ログイン')
            visit tasks_path
            click_link ('アカウント設定')
            expect(page).to have_content('sample3@g.com')
        end

        it '他人の詳細画面にアクセスすると、タスク一覧画面に遷移する' do
          visit new_session_path
          fill_in 'user[email]', with: 'sample3@g.com'
          fill_in 'user[password]', with: 'password'
          click_button ('ログイン')
          visit user_path(second_user)
          expect(page).to have_content('タスク一覧ページ')
        end

        it 'ログアウトするとログイン画面に遷移し、「ログアウトしました」というメッセージが表示される' do
        visit new_session_path
        fill_in 'user[email]', with: 'sample3@g.com'
        fill_in 'user[password]', with: 'password'
        click_button ('ログイン')
        visit tasks_path
        click_link ('ログアウト')
        expect(page).to have_content('ログアウトしました')
        end
     end
   end

    describe '管理者機能' do
      before do
        visit new_session_path
        fill_in 'user[email]', with: 'sample3@g.com'
        fill_in 'user[password]', with: 'password'
        click_button ('ログイン')
      end
      context '管理者がログインした場合' do
        it 'ユーザ一覧画面にアクセスできる' do
          visit admin_users_path(third_user)
          expect(page).to have_content ('ユーザ一覧')
        end

        it '管理者を登録できる' do
          visit new_admin_user_path(third_user)
          fill_in 'user[name]', with: 'jiro'
          fill_in 'user[email]', with: 'sample2@g.com'
          fill_in 'user[password]', with: 'password'
          fill_in 'user[password_confirmation]', with: 'password'
          check "管理者権限"
          click_button '登録する'
          expect(page).to have_content ('ユーザを登録しました')
        end

        it 'ユーザ詳細画面にアクセスできる' do
          visit admin_user_path(third_user)
          expect(page).to have_content ('sample3@g.com')
        end

        it 'ユーザ編集画面から、自分以外のユーザを編集できる' do
          click_link '編集'
          fill_in 'user[name]', with: 'taro'
          fill_in 'user[email]', with: 'sample@g.com'
          fill_in 'user[password]', with: 'password'
          fill_in 'user[password_confirmation]', with: 'password'
          click_button ('更新する')
          expect(page).to have_content 'ユーザを更新しました'
        end

        it 'ユーザを削除できる' do
          visit admin_users_path(third_user)
          click_link ('削除')
          expect(page).to have_content 'ユーザを削除しました'
        end
      end

      context '一般ユーザがユーザ一覧画面にアクセスした場合' do
        it 'タスク一覧画面に遷移し、「管理者以外アクセスできません」というエラーメッセージが表示される' do
          visit admin_users_path(second_user)
          visit tasks_path
          expect(page).to have_content '管理者以外アクセスできません'
        end
      end
    end
end