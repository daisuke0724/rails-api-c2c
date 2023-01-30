require './spec/rails_helper'

RSpec.describe User do

  describe 'user model' do
    context '正常データ登録' do
      example '有効なデータの場合に通ること' do
        user = build(:user)
        expect(user).to be_valid
      end
    end

    context '未入力のとき' do

      example 'email が未入力の場合にエラーメッセージが返ってくること' do
        user = build(:user, email: nil)
        user.valid?
        expect(user.errors).to be_added(:email, :blank)
      end

      example 'password が未入力の場合にエラーメッセージが返ってくること' do
        user = build(:user, password: nil)
        user.valid?
        expect(user.errors).to be_added(:password, :blank)
      end
    end

    context 'フォーマットが合わないとき' do
      example 'email のローカルパートに先頭にドットが入っているとバリデーションエラーが返ってくること' do
        user = build(:user, email: '.a@example.com')
        user.valid?
        expect(user).to be_invalid
      end
      example 'email のローカルパートにダブルドットが入っているとバリデーションエラーが返ってくること' do
        user = build(:user, email: 'a..a@example.com')
        user.valid?
        expect(user).to be_invalid
      end
      example 'email のローカルパートに丸括弧が入っているとバリデーションエラーが返ってくること' do
        user = build(:user, email: '()@example.com')
        user.valid?
        expect(user).to be_invalid
      end
      example 'email のローカルパートに値がない場合にバリデーションエラーが返ってくること' do
        user = build(:user, email: '@example.com')
        user.valid?
        expect(user).to be_invalid
      end
      example 'email のローカルパートに全角文字がある場合にバリデーションエラーが返ってくること' do
        user = build(:user, email: 'あいうえお@example.com')
        user.valid?
        expect(user).to be_invalid
      end
    end

    context '最大桁数未満のとき' do
      example 'name の桁数エラーがないこと' do
        user = build(:user, name: 'a' * 49)
        expect(user).to be_valid
      end
      example 'email の桁数エラーがないこと' do
        user = build(:user, email: '@example.dom'.rjust(254, 'a'))
        expect(user).to be_valid
      end
    end

    context '最大桁数と同値のとき' do
      example 'name の桁数エラーがないこと' do
        user = build(:user, name: 'a' * 50)
        expect(user).to be_valid
      end
      example 'email の桁数エラーがないこと' do
        user = build(:user, email: '@example.dom'.rjust(255, 'a'))
        expect(user).to be_valid
      end
    end

    context '最大桁数を超過したとき' do
      example 'name の桁数エラーが返ってくること' do
        user = build(:user, name: 'a' * 51)
        user.valid?
        expect(user.errors).to be_added(:name, :too_long, :count=>50)
      end
      example 'email の桁数エラーが返ってくること' do
        user = build(:user, email: '@example.dom'.rjust(256, 'a'))
        user.valid?
        expect(user.errors).to be_added(:email, :too_long, :count=>255)
      end
    end
  end
end
