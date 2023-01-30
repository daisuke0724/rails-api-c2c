class Api::V1::UsersController < ApplicationController

  before_action :set_user_list_item, only: [:show, :update, :destroy]

  def create
    user = User.new(user_params)
    user_point = nil

    user.transaction do
      user.save!
      user_point = UserPoint.new(user_id: user.id, point: 10000)
      user_point.save!
    end

    data = {
      user:{
        id: user.id,
        email: user.email,
        created_at: user.created_at,
        updated_at: user.updated_at
      },
      user_point: {
        id: user_point.id,
        user_id: user_point.user_id,
        point: user_point.point,
        created_at: user_point.created_at,
        updated_at: user_point.updated_at
      }
    }

    render json: { status: 'Success', message: 'Created user', data: data }

  rescue => e
    render json: { status: 'Error', message: 'Not created user', data: e.message }

  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

end
