require 'Clover'
require 'Square'

class TestController < ApplicationController
  before_action :authenticate_user!

  def index
    # @square = Square.new(current_user.authentication.token)
    # @clover = Clover.new("#{current_user.access_token}", "#{current_user.merchant_id}")
    # @payments = @square.payments
  end
end
