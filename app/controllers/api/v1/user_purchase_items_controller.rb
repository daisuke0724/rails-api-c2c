class Api::V1::UserPurchaseItemsController < ApplicationController

  def create

    buy_user_id = params[:user_purchase_item][:user_id]
    user_list_item_id = params[:user_purchase_item][:user_list_item_id]

    # 未購入の商品
    user_list_item = UserListItem.find_by(id: user_list_item_id, user_purchase_items_id: nil)

    # 購入済商品の場合はエラー
    if user_list_item.nil?
      render json: { status: 'Error', message: 'This item has already been purchased' } and return
    end

    # 出品者と購入者が同じ場合はエラー
    if user_list_item.user_id.to_s == buy_user_id
      render json: { status: 'Error', message: 'Cannot be purchased because the seller and the buyer are the same' } and return
    end

    # ポイント残高の取得
    point_balance = UserPoint.where(user_id: buy_user_id).sum(:point)
    point = user_list_item.point

    sale_user_id = user_list_item.user_id

    # 残高がマイナスの場合はエラー
    if (point_balance - point) < 0
      render json: { status: 'Error', message: 'Insufficient point balance' } and return
    end

    # トランザクションの開始
    UserPurchaseItem.transaction do
      # 購入データの登録
      user_purchase_item = UserPurchaseItem.new(user_id: buy_user_id, point: point)
      user_purchase_item.save!
      UserPurchaseItem.create!(user_id: buy_user_id, point: point)
      # ポイント履歴　ポイント使用
      UserPoint.create!(user_id: buy_user_id, point: -point)
      # ポイント履歴　ポイント付与
      UserPoint.create!(user_id: sale_user_id, point: point)
      # 出品データの更新
      user_list_item.update!(user_purchase_items_id: user_purchase_item.id)
    end

    data = {
      item_name: user_list_item.name,
      use_point: user_list_item.point
    }

    render json: { status: 'Success', message: 'Purchased the item' data: data }

  rescue => e
    render json: { status: 'Error', message: 'Please buy again later' }
  end

  private

  def user_purchase_items
    params.require(:user_purchase_item).permit(:user_id, :user_list_item_id)
  end
end
