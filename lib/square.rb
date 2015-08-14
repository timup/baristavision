class Square
  include HTTParty # When you HTTParty, you must party hard.
  base_uri 'connect.squareup.com'

  def initialize(access_token)
    @auth = { :headers => { "Authorization" => "Bearer #{access_token}", "Accept" => "application/json" } }
  end

  def payments
    self.class.get("/v1/me/payments", @auth)
  end
end
