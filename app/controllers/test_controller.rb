class TestController < ApplicationController

  def index
    @orders = Order.where(user_id: current_user.id)
    @order_ids = @orders.map{|order| order.id}
    @line_items = LineItem.where(order_id: @order_ids)
  end
end
