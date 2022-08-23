require 'active_support'
require 'active_support/concern'
require_relative "concerns/controllers/base"
require_relative "concerns/controllers/auth"
require_relative "concerns/controllers/hooks"
require_relative "concerns/models/store"
require_relative "./rails/railtie"
require_relative "./rails/engine"

module Fera
  module Apps
    module Rails
    end
  end
end
