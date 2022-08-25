::Rails.application.routes.draw do
  # This route is what the omniauth2 gem uses
  get "auth/fera/callback" => "fera/auth#callback"

  namespace :fera do
    get "auth" => redirect(path: "/auth/fera") # @alias since omniauth gem path is not consistent with our pattern here
    get "auth/check" => "auth#check"
    get "auth/disconnect" => "auth#disconnect"
    get "auth/load" => "auth#load"
    get "auth/success" => "auth#success"
    get "auth/test" => "auth#test"

    # All apps should have an uninstall hook to cleanup data if app is uninstalled from Fera's side
    post "hooks/app_uninstall" => "hooks#app_uninstall"
  end
end
