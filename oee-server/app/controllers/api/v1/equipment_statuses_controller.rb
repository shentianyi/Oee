module Api
  module V1
    class EquipmentStatusesController < Api::V1::ApplicationController
      # guard_all!

      def index
        render json: EquipmentStatus.all.to_json
      end
    end

  end


end