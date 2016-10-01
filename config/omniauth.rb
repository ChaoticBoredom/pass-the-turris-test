Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :yahoo_oauth2,
    Rails.configuration.x.yahoo.client_id,
    Rails.configuration.x.yahoo.client_secret,
    :name => "yahoo"
  )
end
