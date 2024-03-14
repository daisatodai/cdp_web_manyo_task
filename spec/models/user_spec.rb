require 'rails_helper'

RSpec.describe 'ユーザモデル機能', type: :model do
  describe 'バリデーションのテスト' do
    context 'ユーザの名前が空文字の場合' do
      it 'バリデーションに失敗する' do
        user = User.create(name: '', email: 'example@a.com', password: 'password', password_confirmation: 'password')
        expect(user).not_to be_valid
      end
    end

    context 'ユーザのメールアドレスが空文字の場合' do
      it 'バリデーションに失敗する' do
        user = User.create(name: 'taro', email: '', password: 'password', password_confirmation: 'password')
        expect(user).not_to be_valid
      end
    end

    context 'ユーザのパスワードが空文字の場合' do
      it 'バリデーションに失敗する' do
        user = User.create(name: 'taro', email: 'example@a.com', password: '', password_confirmation: '')
        expect(user).not_to be_valid
      end
    end

    context 'ユーザのメールアドレスがすでに使用されていた場合' do
      it 'バリデーションに失敗する' do
        existing_user = FactoryBot.create(:user, email: 'existing@example.com')
        user_with_duplicate_email = FactoryBot.build(:user, email: 'existing@example.com')
        expect(user_with_duplicate_email).not_to be_valid
      end
    end

    context 'ユーザのパスワードが6文字未満の場合' do
      it 'バリデーションに失敗する' do
        user = User.create(name: 'taro', email: 'example@a.com', password: '', password_confirmation: '' )
        expect(user).not_to be_valid
      end
    end

    context 'ユーザの名前に値があり、メールアドレスが使われていない値で、かつパスワードが6文字以上の場合' do
      it 'バリデーションに成功する' do
        user = FactoryBot.build(:user, name: 'John', email: 'new@example.com', password: 'password123')
        expect(user).to be_valid
      end
    end
  end
end


