require 'omniauth-fera'

OmniAuth.config.allowed_request_methods = [:get, :post]

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :fera,
           ENV.fetch('FERA_CLIENT_ID', nil),
           ENV.fetch('FERA_CLIENT_SECRET', nil),
           callback_url: ENV.fetch('FERA_REDIRECT_URI', nil),
           scope: ENV.fetch('FERA_CLIENT_SCOPES', "read write"),
           client_options: { site: ENV["FERA_APP_URL"].presence || ENV["FERA_PROVIDER_URL"].presence || "https://app.fera.ai" }
end
