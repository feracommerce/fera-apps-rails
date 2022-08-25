module Fera
  module Apps
    module Controllers
      module Auth
        extend ActiveSupport::Concern

        included do
          before_action :load_store_from_jwt!, only: [:load, :test, :check]
        end

        ##
        # GET /auth/fera/callback
        def callback
          if @store.try(:fera_id) != params[:store_id]
            @store = ::Store.find_or_initialize_by(fera_id: params[:store_id]) # Fera::Store also exists so make sure to include `::` prefix to reference right class
          end
          @store.install_fera!(request)

          set_current_store(@store)

          after_fera_callback
        end

        ##
        # You should override this in your own controller.
        def after_fera_callback
          ::Rails.logger.warn("#after_fera_callback not implemented in your controller, so the default action was to redirect to the root_path")
          redirect_to root_path
        end

        ##
        # Override this to send them someone else
        # @GET /fera/auth/load
        def load
          redirect_to root_path
        end

        ##
        # @GET /fera/auth/disconnect
        def disconnect
          if @store.present?
            @store.destroy!
            redirect_to root_path, notice: "Disconnected app from Fera successfully."
          else
            redirect_to root_path, flash: { error: "Not connected to Fera, so disconnecting did nothing." }
          end
        end

        ##
        # @GET /fera/auth/test
        def test
          respond_to do |format|
            format.json { render json: status_result, status: status_result[:status] }
            format.html do
              redirect_to fera_app_relay_url(status_result[:status], status_result[:message])
            end
          end
        end

        ##
        # GET /fera/auth/success
        def success
          redirect_to fera_app_relay_url(fera_app_connect_success_msg)
        end

        ##
        # GET /fera/auth/check
        # GET /fera/auth/check.json
        def check
          respond_to do |format|
            format.json { render json: status_result, status: status_result[:status] }
            format.html do
              redirect_to root_path, (status_result[:status] == :connected ? :notice : :alert) => status_result[:message], status: status_result[:status]
            end
          end
        end

        private

        def status_result
          @status_result ||= generate_status_response || { status: :ok, message: "Everything appears to be operational!" }
        end

        ##
        # Override this to set a custom message
        def fera_app_connect_success_msg
          "Connected #{ ENV.fetch('APP_NAME', 'app') } to Fera successfully!"
        end

        ##
        # Returns nil if everything is OK.
        # Otherwise returns the status code and error message.
        #
        # @return [Hash, NilClass] with two keys: :status and :message. Status should be a symbol that matches the strings at HTTP_STATUS_CODES
        def generate_status_response
          if @store.blank?
            { status: :not_found, message: "App not installed." }
          elsif !@store.connected_to_fera?
            { status: :not_authorized, message: "Fera app not installed." }
          elsif !@store.check_fera_connection
            { status: :server_error, message: "Fera connection lost. Please re-install the Fera app." }
          else
            nil # Everything is OK
          end
        end

        def load_store_from_jwt!
          data = $fera_app.decode_jwt(params[:jwt])

          if data.blank?
            message = "Something went wrong. Try refreshing the page and connecting your Fera account."
            respond_to do |format|
              format.json { render json: { message: message }, status: :unauthorized }
              format.html { redirect_to root_path, alert: message }
            end
          else
            @store = ::Store.find_by(fera_id: data[:store_id]) # Fera::Store also exists so make sure to include `::` prefix to reference right class
            set_current_store(@store)
          end
        end

        ##
        # @param message [String] Message to display to the user in Fera app
        # @param status [Symbol, Integer] Status, from Rack::Utils::HTTP_STATUS_CODES. Default: :ok, which is 200 and success
        def fera_app_relay_url(message, status: :ok)
          url = "#{ ENV.fetch('FERA_APP_URL', 'https://app.fera.ai').chomp('/') }/integrations/apps/#{ ENV.fetch('APP_CODE', nil) }/relay"
          "#{ url }?jwt=#{ $fera_app.encode_jwt(store_id: @store.fera_id, message: message, exp: 1.hour.from_now.to_i, status: status) }"
        end
      end
    end
  end
end
