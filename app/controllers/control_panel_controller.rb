class ControlPanelController < ApplicationController
  def index
    if current_user
      @devices = current_user.devices
    end
  end

  def new
  end

  def create
  end

  def destroy
  end
end
