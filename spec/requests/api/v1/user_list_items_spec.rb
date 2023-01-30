require 'rails_helper'

RSpec.describe "Api::V1::UserListItems", type: :request do
  describe "POST /create" do
    context '商品登録（出品）' do

      let(:user) { FactoryBot.create(:user) }

      example '商品登録（出品）に成功した場合に status: Success が返却される' do

        user_id = user.id

        user_list_item_params = {
          user_id: user_id,
          name: 'item1',
          point: 3000
        }

        expect { post '/api/v1/user_list_items', params: { user_list_item: user_list_item_params } }.to change(UserListItem, :count).by(+1)

        # HTTPステータスコード確認
        expect(response.status).to eq(200)

        response_json = JSON.parse(response.body)
        expect(response_json['status']).to include('Success')

      end
      example '商品登録（出品）に失敗した場合に status: Error が返却される' do

        user_list_item_params = {
          user_id: '',
          name: 'item1',
          point: 3000
        }

        post '/api/v1/user_list_items', params: { user_list_item: user_list_item_params }

        # HTTPステータスコード確認
        expect(response.status).to eq(200)

        response_json = JSON.parse(response.body)
        expect(response_json['status']).to include('Error')
      end
    end
  end
  describe "PUT /update" do
    context '商品データ更新' do
      let(:user_list_item) { FactoryBot.create(:user_list_item) }
      let(:user_purchase_item) { FactoryBot.create(:user_purchase_item) }
      let(:user_point) { FactoryBot.create(:user_point) }

      example '商品データ更新に成功した場合に  status: Success が返却される' do

        user_list_item_params = {
          point: 5000
        }

        put "/api/v1/user_list_items/#{user_list_item.id}", params: { user_list_item: user_list_item_params }

        # HTTPステータスコード確認
        expect(response.status).to eq(200)

        response_json = JSON.parse(response.body)
        expect(response_json['status']).to include('Success')
      end
      example '商品データ更新に失敗した場合に  status: Error が返却される' do

        user_list_item_params = {
          user_id: '',
          point: 5000
        }

        put "/api/v1/user_list_items/#{user_list_item.id}", params: { user_list_item: user_list_item_params }
        # HTTPステータスコード確認
        expect(response.status).to eq(200)

        response_json = JSON.parse(response.body)
        expect(response_json['status']).to include('Error')
      end
      example '購入済の商品データを更新しようとした場合に status: Error が返却される' do

        user_purchase_item_params = {
          user_id: user_point.user_id,
          user_list_item_id: user_list_item.id
        }

        expect { post '/api/v1/user_purchase_items', params: { user_purchase_item: user_purchase_item_params } }.to change(UserPurchaseItem, :count).by(+1)

        user_list_item_params = {
          point: 3000
        }

        put "/api/v1/user_list_items/#{user_list_item.id}", params: { user_list_item: user_list_item_params }

        # HTTPステータスコード確認
        expect(response.status).to eq(200)

        response_json = JSON.parse(response.body)
        expect(response_json['status']).to include('Error')
      end
    end
  end
  describe "DELETE /destroy" do
    context '商品データ削除' do

      let(:user_list_item) { FactoryBot.create(:user_list_item) }
      let(:user_purchase_item) { FactoryBot.create(:user_purchase_item) }
      let(:user_point) { FactoryBot.create(:user_point) }

      example '商品データの削除に成功した場合に  status: Success が返却される' do

        expect { delete "/api/v1/user_list_items/#{user_list_item.id}" }.to change(UserListItem, :count).by(0)

        # HTTPステータスコード確認
        expect(response.status).to eq(200)

        response_json = JSON.parse(response.body)
        expect(response_json['status']).to include('Success')
      end
      example '購入済の商品データを削除しようとした場合に status: Error が返却される' do

        user_purchase_item_params = {
          user_id: user_point.user_id,
          user_list_item_id: user_list_item.id
        }

        expect { post '/api/v1/user_purchase_items', params: { user_purchase_item: user_purchase_item_params } }.to change(UserPurchaseItem, :count).by(+1)

        delete "/api/v1/user_list_items/#{user_list_item.id}"

        # HTTPステータスコード確認
        expect(response.status).to eq(200)

        response_json = JSON.parse(response.body)
        expect(response_json['status']).to include('Error')
      end
    end
  end
end