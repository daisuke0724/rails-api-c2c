require 'rails_helper'

RSpec.describe "Api::V1::UserPurchaseItems", type: :request do
  describe "POST /create" do
    context '商品購入' do

      let(:user_list_item) { FactoryBot.create(:user_list_item) }
      let(:user_point) { FactoryBot.create(:user_point) }

      example '商品購入に成功した場合に status: Success が返却される' do

        user_purchase_item_params = {
          user_id: user_point.user_id,
          user_list_item_id: user_list_item.id
        }

        expect { post '/api/v1/user_purchase_items', params: { user_purchase_item: user_purchase_item_params } }.to change(UserPurchaseItem, :count).by(1)

        # HTTPステータスコード確認
        expect(response.status).to eq(200)

        response_json = JSON.parse(response.body)
        expect(response_json['status']).to include('Success')
        expect(response_json['message']).to include('Purchased the item')
      end

      example '購入済商品を購入しようとした場合に status: Error が返却される' do
        user_purchase_item_params = {
          user_id: user_point.user_id,
          user_list_item_id: user_list_item.id
        }

        expect { post '/api/v1/user_purchase_items', params: { user_purchase_item: user_purchase_item_params } }.to change(UserPurchaseItem, :count).by(1)
        expect { post '/api/v1/user_purchase_items', params: { user_purchase_item: user_purchase_item_params } }.to change(UserPurchaseItem, :count).by(0)

        # HTTPステータスコード確認
        expect(response.status).to eq(200)

        response_json = JSON.parse(response.body)
        expect(response_json['status']).to include('Error')
        expect(response_json['message']).to include('This item has already been purchased')
      end
      example '購入しようとしている商品の出品者と購入者が同じ場合に status: Error が返却される' do

        user_purchase_item_params = {
          user_id: user_list_item.user_id,
          user_list_item_id: user_list_item.id
        }

        expect { post '/api/v1/user_purchase_items', params: { user_purchase_item: user_purchase_item_params } }.to change(UserPurchaseItem, :count).by(0)

        # HTTPステータスコード確認
        expect(response.status).to eq(200)

        response_json = JSON.parse(response.body)
        expect(response_json['status']).to include('Error')
        expect(response_json['message']).to include('Cannot be purchased because the seller and the buyer are the same')
      end
      example '残高不足の場合に status: Error が返却される' do

        user_list_item_1 = create(:user_list_item, point: 5001)
        user_list_item_2 = create(:user_list_item, point: 5001)

        user_purchase_item_params = {
          user_id: user_point.user_id,
          user_list_item_id: user_list_item_1.id
        }

        expect { post '/api/v1/user_purchase_items', params: { user_purchase_item: user_purchase_item_params } }.to change(UserPurchaseItem, :count).by(1)

        user_purchase_item_params = {
          user_id: user_point.user_id,
          user_list_item_id: user_list_item_2.id
        }

        expect { post '/api/v1/user_purchase_items', params: { user_purchase_item: user_purchase_item_params } }.to change(UserPurchaseItem, :count).by(0)
        # HTTPステータスコード確認
        expect(response.status).to eq(200)

        response_json = JSON.parse(response.body)
        expect(response_json['status']).to include('Error')
        expect(response_json['message']).to include('Insufficient point balance')
      end

      example '2人のユーザが同時に同じ商品を購入しようとした場合に point 周りがの計算が狂いなく登録されること' do
        user_point_1 = create(:user_point)
        user_point_2 = create(:user_point)
        user_list_item_id = user_list_item.id

        threads = []
        threads << Thread.new do
          # 実行時間（マイクロ秒）チェック
          # p "threads1:#{Time.now.iso8601(6)}"
          user_purchase_item_params1 = {
            user_id: user_point_1.user_id,
            user_list_item_id: user_list_item_id
          }
          post '/api/v1/user_purchase_items', params: { user_purchase_item: user_purchase_item_params1 }
        end
        threads << Thread.new do
          # 実行時間（マイクロ秒）チェック
          # p "threads1:#{Time.now.iso8601(6)}"
          user_purchase_item_params2 = {
            user_id: user_point_2.user_id,
            user_list_item_id: user_list_item_id
          }
          post '/api/v1/user_purchase_items', params: { user_purchase_item: user_purchase_item_params2 }
        end

        threads.each(&:join)

        user_list_item = UserListItem.select(:user_purchase_items_id).find(user_list_item_id)
        user_purchase_item = UserPurchaseItem.find(user_list_item.user_purchase_items_id)
        point1 = UserPoint.where(user_id: user_point_1.user_id).sum(:point).to_i
        point2 = UserPoint.where(user_id: user_point_2.user_id).sum(:point).to_i

        expect(point1 + point2).to eq 17000
        expect(user_purchase_item.point.to_i).to eq 3000
      end
    end
  end
end
