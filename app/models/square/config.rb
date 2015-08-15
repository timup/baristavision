module Square
  class Config

    class_attribute :base_url

    self.base_url = 'connect.squareup.com'

    Square::Base.base_uri base_url

  end
end
