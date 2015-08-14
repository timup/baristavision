class ControlPanelController < ApplicationController
  def index
    @devices = current_user.devices
  end

  def new
  end

  def create
  end

  def destroy
  end
end
