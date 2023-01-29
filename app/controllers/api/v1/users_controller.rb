class Api::V1::UsersController < ApplicationController

  before_action :set_user_list_item, only: [:show, :update, :destroy]

  def create
    user = User.new(user_params)

    user.transaction do
      user.save!
      user_point = UserPoint.new(user_id: user.id, point: 10000); user_point.save!
    end

    data = {
      id: user.id,
      email: user.email
    }

    render json: { status: 'Success', data: data }

  rescue => e
    render json: { status: 'Error', data: e.message }

  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

end
