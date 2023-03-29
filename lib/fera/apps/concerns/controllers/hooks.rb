module Fera
  module Apps
    module Controllers
      module Hooks
        extend ActiveSupport::Concern

        included do
          # Since these are webhooks we will validate the signatures using JWT as per Fera docs, so we don't need Rails to do it's
          # default security token checks upon POST requests.
          skip_forgery_protection

          before_action :load_store_from_token
        end

        ##
        # POST /fera/hooks/app_uninstall
        # All apps should have an uninstall hook to cleanup data if app is uninstalled from Fera's side
        def app_uninstall
          if @store.present?
            @store.destroy!

            ::Rails.logger.info("Deleted store #{ @store.id } triggered by Fera uninstall webhook.")
          end

          head :ok
        end

        # ##
        # # This is just here as an example
        # # POST /fera/hooks/review_create
        # def review_create
        #   ::Rails.logger.info("Received review_create webhook from Fera for store ##{ @store.id } and review ##{ params[:id] }.")
        #
        #   # You'll get a post here with the review data as well as the review id if you want to grab a fresh copy.
        #   # If you want a fresh review copy you do this:
        #   # @store.fera_api do
        #   #   review = Fera::Review.find(params[:id])
        #   #   puts "Wow, that's a sweet new #{ review.stars } review from #{ review.customer.display_name }: #{ review.body }"
        #   # end
        #
        #   head :ok
        # end

        private

        def load_store_from_token
          @token_data = $fera_app.decode_jwt(params[:jwt])
          @store = ::Store.find_by(fera_id: @token_data[:store_id]) # Fera::Store also exists so make sure to include `::` prefix to reference right class
        end
      end
    end
  end
end
