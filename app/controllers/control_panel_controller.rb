class ControlPanelController < ApplicationController
  def index
    if current_user
      @devices = current_user.devices
      @items = current_user.items
      @orders = current_user.orders
    end
  end

  def new
  end

  def create
  end

  def destroy
  end
end
