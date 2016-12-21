module Api
  module V1
    class EquipmentTracksController < Api::V1::ApplicationController
      # guard_all!

      def index

      end

      def nameplate_list
        render json: ['铭牌完好', "铭牌损坏", "铭牌丢失"]
      end


    end

  end


end