require 'json'
require 'hashie'

class Square
  include HTTParty # When you HTTParty, you must party hard.
  format :json
  base_uri 'connect.squareup.com'

  def initialize(access_token)
    @auth = { :headers => { "Authorization" => "Bearer #{access_token}", "Accept" => "application/json" } }
  end

  def payments
    response = self.class.get("/v1/me/payments", @auth)
    payments = JSON.parse(response.body)
    payments.each do |payment|
      Hashie::Mash.new(payment)
    end

  end
end
