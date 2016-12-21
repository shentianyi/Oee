module Api
  module V1
    class BuMangersController < Api::V1::ApplicationController
      # guard_all!

      def index
        data =[]
        BuManger.all.each do |i|
          data<<{id: i.id.to_s, name: i.nr}
        end

        render json: data.to_json
      end
    end

  end


end