class Api::V1::UserListItemsController < ApplicationController

  before_action :set_user_list_item, only: [:update, :destroy]

  def create
    user_list_item = UserListItem.new(user_list_item_params)

    if user_list_item.save
      render json: { status: 'Success', message: 'Created list item', data: user_list_item }
    else
      render json: { status: 'Error', message: 'Not created list item', data: user_list_item.errors }
    end
  end

  def update

    if @user_list_item.user_purchase_items_id.present?
      render json: { status: 'Error', message: 'This item has already been purchased and cannot be updated', data: @user_list_item } and return
    end

    if @user_list_item.update(user_list_item_params)
      render json: { status: 'Success', message: 'Updated list item', data: @user_list_item }
    else
      render json: { status: 'Error', message: 'Not updated list item', data: @user_list_item.errors }
    end
  end

  def destroy
    if @user_list_item.user_purchase_items_id.present?
      render json: { status: 'Error', message: 'This item has already been purchased and cannot be deleted', data: @user_list_item } and return
    end

    @user_list_item.destroy
    render json: { status: 'Success', message: 'Deleted list item', data: @user_list_item }
  end

  private

  def set_user_list_item
    @user_list_item = UserListItem.find(params[:id])
  end

  def user_list_item_params
    params.require(:user_list_item).permit(:user_id, :name, :point)
  end
end
