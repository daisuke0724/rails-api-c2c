class Api::V1::UserListItemsController < ApplicationController

  before_action :set_user_list_item, only: [:update, :destroy]

  def create
    user_list_item = UserListItem.new(user_list_item_params)

    if user_list_item.save
      render json: { status: 'Success', data: user_list_item }
    else
      render json: { status: 'Error', data: user_list_item.errors }
    end
  end

  def update

    if @user_list_item.user_purchase_items_id.nil?
      render json: { status: 'Error', message: 'Not updated', data: @user_list_item } and return
    end

    if @user_list_item.update(user_list_item_params)
      render json: { status: 'Success', message: 'Updated', data: @user_list_item }
    else
      render json: { status: 'Error', message: 'Not updated', data: @user_list_item.errors }
    end
  end

  def destroy
    if @user_list_item.user_purchase_items_id.nil?
      render json: { status: 'Error', message: 'Not deleted', data: @user_list_item }
    end

    @user_list_item.destroy
    render json: { status: 'Success', message: 'Deleted', data: @user_list_item }
  end

  private

  def set_user_list_item
    @user_list_item = UserListItem.find(params[:id])
  end

  def user_list_item_params
    params.require(:user_list_item).permit(:user_id, :name, :point)
  end
end
