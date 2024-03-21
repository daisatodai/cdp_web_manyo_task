require 'rails_helper'
  RSpec.describe 'ラベルモデル機能', type: :model do
    describe 'バリデーションのテスト' do
      context 'ラベルの名前が空文字の場合' do
        it 'バリデーションに失敗する' do
          label = Label.create(name: '')
          expect(label).not_to be_valid
        end
      end

      context 'ラベルの名前に値があった場合' do
        let!(:first_user) { FactoryBot.create(:first_user) }
        it 'バリデーションに成功する' do
          label = first_user.labels.build(name: 'ruby')
          expect(label).to be_valid
        end
      end
    end
  end