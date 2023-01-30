require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  describe "POST /create" do
    context 'ユーザ登録' do
      example 'ユーザ登録に成功した場合に status: Success が返却される' do

        user_params = {
          email: 'aaa@example.com',
          password: 'password'
        }

        # user と user_point テーブルへデータが作成されている事を確認
        expect { post '/api/v1/users', params: { user: user_params } }.to change(User, :count).by(+1).and change(UserPoint, :count).by(+1)

        # HTTPステータスコード確認
        expect(response.status).to eq(200)

        response_json = JSON.parse(response.body)
        expect(response_json['data']['user_point']['point'].to_i).to eq 10000
        expect(response_json['status']).to include('Success')
        expect(response_json['message']).to include('Created user')
      end
      example 'ユーザ登録に失敗した場合に status: Error が返却される' do

        user_params = {
          email: 'aaa@example.com',
          password: 'password'
        }

        # データが作成されている事を確認
        expect { post '/api/v1/users', params: { user: user_params } }.to change(User, :count).by(1)

        # 同一データをリクエストする
        expect { post '/api/v1/users', params: { user: user_params } }.to change(User, :count).by(0)

        # HTTPステータスコード確認
        expect(response.status).to eq(200)

        response_json = JSON.parse(response.body)
        expect(response_json['status']).to include('Error')
        expect(response_json['message']).to include('Not created user')
      end
    end
  end
end
