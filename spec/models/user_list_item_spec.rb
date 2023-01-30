require 'rails_helper'

RSpec.describe UserListItem, type: :model do
  describe 'user_list_item model' do
    context '正常データ登録' do
      example '有効なデータの場合に通ること' do
        user_list_item = build(:user_list_item)
        expect(user_list_item).to be_valid
      end
    end

    context '最大桁数未満のとき' do
      example 'name の桁数エラーがないこと' do
        user_list_item = build(:user_list_item, name: "a" * 99)
        expect(user_list_item).to be_valid
      end
      example 'point の桁数エラーがないこと' do
        user_list_item = build(:user_list_item, point: 999999)
        expect(user_list_item).to be_valid
      end
    end

    context '最大桁数と同値のとき' do
      example 'name の桁数エラーがないこと' do
        user_list_item = build(:user_list_item, name: "a" * 100)
        expect(user_list_item).to be_valid
      end
      example 'point の桁数エラーがないこと' do
        user_list_item = build(:user_list_item, point: 1000000)
        expect(user_list_item).to be_valid
      end
    end

    context '最大桁数を超過したとき' do
      example 'name の桁数エラーがないこと' do
        user_list_item = build(:user_list_item, name: "a" * 101)
        user_list_item.valid?
        expect(user_list_item.errors).to be_added(:name, :too_long, :count=>100)
      end
      example 'point の桁数エラーが返ってくること' do
        user_list_item = build(:user_list_item, point: 1000001)
        user_list_item.valid?
        expect(user_list_item.errors).to be_added(:point, :less_than_or_equal_to, :value => 1000001, :count => 1000000)
      end
    end

    context '最低桁数未満のとき' do
      example 'point の桁数エラーが返ってくること' do
        user_list_item = build(:user_list_item, point: -1000001)
        user_list_item.valid?
        expect(user_list_item.errors).to be_added(:point, :greater_than_or_equal_to, :value => -1000001, :count => -1000000)
      end
    end

    context '最低桁数と同値のとき' do
      example 'point の桁数エラーがないこと' do
        user_list_item = build(:user_list_item, point: -1000000)
        expect(user_list_item).to be_valid
      end
    end

    context '最低桁数を超過したとき' do
      example 'point の桁数エラーがないこと' do
        user_list_item = build(:user_list_item, point: -999999)
        expect(user_list_item).to be_valid
      end
    end
  end
end
