class CloverWorker
  include Sidekiq::Worker
  sidekiq_options queue: "high"
  # sidekiq_options retry: false

  def perform(provider_order_id)
    order = Order.find_by(provider_order_id: provider_order_id)
    call = Api::Call.new(current_user.authentication)
    call.connect.order(order.provider_order_id)
  end
end
