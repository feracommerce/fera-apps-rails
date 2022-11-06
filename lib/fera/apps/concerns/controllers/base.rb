module Fera
  module Apps
    module Controllers
      module Base
        extend ActiveSupport::Concern

        included do
          before_action :store
        end

        private

        def configure_fera_api_for_store!(&block)
          if @store.try(:connected_to_fera?) && @store.fera_auth_token.present?
            Fera::API.configure(@store.fera_auth_token, api_url: ENV.fetch("FERA_API_URL", nil), &block)
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
          session[:store_id] = store.id
          @store = store
        end
      end
    end
  end
end
