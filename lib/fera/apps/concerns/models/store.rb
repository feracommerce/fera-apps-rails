module Fera
  module Apps
    module Models
      module Store
        extend ActiveSupport::Concern

        included do
          define_model_callbacks :install_fera
          define_model_callbacks :uninstall_fera

          scope :with_fera_id, -> (fera_id) { where(fera_id: fera_id) }

          before_destroy :revoke_fera_token!, if: -> { fera_auth_token.present? }

          validates_uniqueness_of :fera_id, if: :connected_to_fera?
          validates :fera_domain, presence: true, if: :connected_to_fera?
          validates :fera_domain, format: { with: /\A[a-z0-9][a-z0-9.-]+[a-z]\z/i, message: "can only contain letters, numbers, . or -" }, if: :connected_to_fera?
        end

        def install_fera!(request)
          run_callbacks(:install_fera) do
            auth_data = request.env['omniauth.auth']['credentials']

            self.fera_auth_token = auth_data['token']
            self.fera_domain = request.params[:store_domain]

            save!

            fera_api do
              install_fera_webhooks!
            end
          end
        end

        def connected_to_fera?
          fera_auth_token.present?
        end
        alias_method :fera_connected?, :connected_to_fera?

        def check_fera_connection
          return false unless connected_to_fera?

          fera_api do
            ::Fera::Store.current
          end

          true
        rescue ActiveResource::ConnectionError
          false
        end

        def disconnect_fera!
          revoke_fera_token! if connected_to_fera?

          remove_fera_attributes!
        end

        def install_fera_webhooks!
          # Here is some example code you can use to install webhooks:
          #
          # hook = Fera::Webhook.where(event_name: :review_create).try(:first)
          # hook ||= Fera::Webhook.new(event_name: :review_create)
          # hook.is_enabled = true
          # hook.url = "#{ ENV.fetch('BASE_APP_URL', nil) }/fera/hooks/review_create"
          # hook.save!
        end

        private

        def revoke_fera_token!
          return unless fera_auth_token.present?

          $fera_app.revoke_token!(fera_auth_token)
        end

        def remove_fera_attributes!
          update(
            fera_id: nil,
            fera_auth_token: nil,
            fera_domain: nil
          )
        end

        ##
        # Run Fera::API methods in the scope of the current store.
        # fera_api { ::Fera::Store.current }
        # @return [Object] Result of block provided
        def fera_api(&block)
          Fera::API.configure(fera_auth_token,
                              api_url: ENV.fetch("FERA_API_URL", nil),
                              &block)
        end
      end
    end
  end
end
