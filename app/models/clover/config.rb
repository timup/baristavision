module Clover
  class Config

    class_attribute :base_url

    self.base_url = 'api.clover.com:443'

    Clover::Base.base_uri base_url

  end
end
