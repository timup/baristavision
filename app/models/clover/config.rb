module Clover
  class Config

    class_attribute :base_url, :access_token, :merchant_id

    self.base_url = 'api.clover.com:443'
    # self.access_token = current_user.authentication.token
    # self.merchant_id = current_user.authentication.merchant_id

    Clover::Base.base_uri base_url

  end
end
