class Webhooks::MainController < ApplicationController
  skip_before_filter :authenticate_user!
  protect_from_forgery :except => :test

  # /webhooks/test
  def test
    data = request.body.read
    data = JSON.parse(data)
    puts data
    render nothing: true
  end
end
