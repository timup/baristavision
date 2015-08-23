module Api
  class Config

    class_attribute :clover_url, :square_url

    self.clover_url = 'api.clover.com:443'
    self.square_url = ''
  end
end
