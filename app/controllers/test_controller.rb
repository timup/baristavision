require 'Clover'
require 'Square'

class TestController < ApplicationController

  def index
    @square = Square.new(current_user.authentication.token)
    @payments = @square.payments
    # @clover = Clover.new("#{current_user.access_token}", "#{current_user.merchant_id}")

  end
end
