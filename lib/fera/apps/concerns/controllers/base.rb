module Fera
  module Apps
    module Controllers
      module Base
        extend ActiveSupport::Concern

        included do
          before_action :store
        end

        private

        def load_store
          if session[:store_id].present?
            Store.find(session[:store_id])
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
