require 'rails_helper'

RSpec.describe UserPoint, type: :model do

  describe 'user_point model' do
    context '正常データ登録' do
      example '有効なデータの場合に通ること' do
        user_point = build(:user_point)
        expect(user_point).to be_valid
      end
    end

    context '最大桁数未満のとき' do
      example 'point の桁数エラーがないこと' do
        user_point = build(:user_point, point: 999999)
        expect(user_point).to be_valid
      end
    end

    context '最大桁数と同値のとき' do
      example 'point の桁数エラーがないこと' do
        user_point = build(:user_point, point: 1000000)
        expect(user_point).to be_valid
      end
    end

    context '最大桁数を超過したとき' do
      example 'point の桁数エラーが返ってくること' do
        user_point = build(:user_point, point: 1000001)
        user_point.valid?
        expect(user_point.errors).to be_added(:point, :less_than_or_equal_to, :value => 1000001, :count => 1000000)
      end
    end

    context '最低桁数未満のとき' do
      example 'point の桁数エラーが返ってくること' do
        user_point = build(:user_point, point: -1000001)
        user_point.valid?
        expect(user_point.errors).to be_added(:point, :greater_than_or_equal_to, :value => -1000001, :count => -1000000)
      end
    end

    context '最低桁数と同値のとき' do
      example 'point の桁数エラーがないこと' do
        user_point = build(:user_point, point: -1000000)
        expect(user_point).to be_valid
      end
    end

    context '最低桁数を超過したとき' do
      example 'point の桁数エラーがないこと' do
        user_point = build(:user_point, point: -999999)
        expect(user_point).to be_valid
      end
    end
  end
end
