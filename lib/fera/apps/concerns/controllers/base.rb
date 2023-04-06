module Fera
  module Apps
    module Controllers
      module Base
        extend ActiveSupport::Concern

        included do
          before_action :store
        end

        private

        ##
        # Use like this: `around_action :configure_fera_api_for_store!` to configure the API client
        # for controller actions.
        def configure_fera_api_for_store!(&block)
          if @store.try(:connected_to_fera?) && @store.fera_auth_token.present?
            Fera::API.configure(@store.fera_auth_token, api_url: ENV.fetch("FERA_API_URL", nil), &block)
          else
            yield
          end
        end

        def load_store
          if session[:store_id].present?
            ::Store.find(session[:store_id])
          else
            nil
          end
        rescue ActiveRecord::RecordNotFound
          nil
        end

        def store
          @store ||= load_store
        end

        def set_current_store(store) # rubocop:disable Naming/AccessorMethodName
          session[:store_id] = store.try(:id)
          @store = store
        end
      end
    end
  end
end
