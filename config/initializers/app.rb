# This is to interact with the Fera APP globally
$fera_app = Fera::App.new(ENV.fetch("FERA_CLIENT_ID", nil), ENV.fetch("FERA_CLIENT_SECRET", nil),
                          app_url: ENV.fetch("FERA_APP_URL", nil),
                          api_url: ENV.fetch("FERA_API_URL", nil),
                          debug_mode: ::Rails.env.development?)
