module Api
  module V1
    class BuMangersController < Api::V1::ApplicationController
      # guard_all!

      def index
        render json: BuManger.all.to_json
      end
    end

  end


end