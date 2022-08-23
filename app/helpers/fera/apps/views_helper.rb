module Fera
  module Apps
    module ViewsHelper
      def last_deployed_at
        @last_deployed_at ||= File.exist?("tmp/pids") ? File.mtime("tmp/pids") : Time.now.utc
      end

      def render_fera_app_footer
        render(partial: "fera/apps/layout/footer")
      end

      def render_fera_app_header
        render(partial: "fera/apps/layout/header")
      end

      def render_fera_app_flash_messages
        render(partial: "fera/apps/flash_messages")
      end

      def render_fera_app_layout(&block)
        render(layout: "fera/apps/layout/content") do
          capture(&block)
        end
      end
    end
  end
end
