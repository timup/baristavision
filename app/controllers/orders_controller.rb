class OrdersController < ApplicationController
  include ActionController::Live

  def index
    response.headers['Content-Type'] = 'text/event-stream'
    sse = SSE.new(response.stream)
    begin
      Order.on_change do |id|
        order = Order.find(id)
        t = render_to_string(partial: 'order', formats: [:html], locals: {order: order})
        sse.write(t)
      end
    rescue IOError
    # Client Disconnected
    ensure
      sse.close
    end
    render nothing: true
  end

  def new
    @device_links = Device.where(user_id: current_user.id)

    if params[:items] == nil
      @orders = Order.where(user_id: current_user.id)
    else
      @orders = Order.where(user_id: current_user.id)
    end

    if params[:device_id] == nil
      @selected_device = nil
    else
      @selected_device = Device.find(params[:device_id]).name
    end
  end

end
