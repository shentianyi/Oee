module Api
  module V1
    class AreasController < Api::V1::ApplicationController
      # guard_all!

      def index
        render json: Area.all.to_json
      end
    end

  end


end