module Api
  module V1
    class ApplicationController < ActionController::API
      include ::APIGuard
      # guard_all!

    end
  end
end