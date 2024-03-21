require 'rails_helper'
RSpec.describe 'ラベル管理機能', type: :system do
  let!(:first_user) { FactoryBot.create(:first_user)}
  before do
    visit new_session_path
    fill_in('session_email', with: 'taro@g.com')
    fill_in('session_password', with: 'password')
    click_button 'ログイン'
  end
  describe '登録機能' do
    context 'ラベルを登録した場合' do
      it '登録したラベルが表示される' do
        visit new_label_path
        fill_in('label_name', with: "ruby")
        click_button("登録する")
        expect(page).to have_text('ラベルを登録しました')
        expect(page).to have_content 'ruby'
      end
    end
  end
  describe '一覧表示機能' do
    let!(:first_user) { FactoryBot.create(:first_user) }
    let!(:second_user) { FactoryBot.create(:second_user) }
    context '一覧画面に遷移した場合' do
      it '登録済みのラベル一覧が表示される' do
        before do
          visit new_session_path
          fill_in('session_email', with: 'taro@g.com')
          fill_in('session_password', with: 'password')
          click_button 'ログイン'
        end
        click_link('ラベル一覧')
        expect(page).to have_content 'ruby'
        expect(page).to have_content 'css'
      end
    end
  end
end