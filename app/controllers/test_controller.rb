class TestController < ApplicationController
  before_action :authenticate_user!

  def index
    @me = Square::Connect::Merchant.me current_user.authentication.token
    @payments = @me.payments
  end
end
