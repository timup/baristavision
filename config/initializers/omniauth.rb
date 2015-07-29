Rails.application.config.middleware.use OmniAuth::Builder do
  provider :clover, "APP_ID", "APP_SECRET"
  provider :square, "consumer_key", "consumer_secret",
    {
        :connect_site  => 'https://connect.squareup.com'
    }
end
