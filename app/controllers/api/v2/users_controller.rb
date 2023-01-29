class Api::V2::UsersController < ApplicationController

  before_action :set_user_list_item, only: [:show, :update, :destroy]

  def index
    users = User.select(:id, :email, :name).order(created_at: :desc)
    render json: { status: 'Success', message: 'Loaded', data: users }
  end

  def show

    data = {
      id: @user.id,
      email: @user.email,
      name: @user.name
    }

    render json: { status: 'Success', message: 'Loaded', data: data }
  end

  def create
    user = User.new(user_params)

    user.transaction do
      user.save!
      user_point = UserPoint.new(user_id: user.id, point: 10000); user_point.save!
    end

    data = {
      id: user.id,
      email: user.email,
      name: user.name
    }

    render json: { status: 'Success', data: data }

  rescue => e
    render json: { status: 'Error', data: e.message }

  end

  def update
    if @user.update(user_params)

      data = {
        id: @user.id,
        email: @user.email,
        name: @user.name
      }

      render json: { status: 'Success', message: 'Updated', data: data }
    else
      render json: { status: 'Success', message: 'Not updated', data: @user.errors }
    end
  end

  def destroy
    @user.destroy

    data = {
      id: @user.id,
      email: @user.email,
      name: @user.name
    }

    render json: { status: 'Success', message: 'Deleted', data: data }
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :name)
  end
end
