module Api
  module V1
    class EquipmentStatusesController < Api::V1::ApplicationController
      # guard_all!

      def index
        data =[]
        EquipmentStatus.all.each do |i|
          data<<{id: i.id.to_s, name: i.name}
        end

        render json: data.to_json
      end
    end

  end


end