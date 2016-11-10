module Api
  module V1
    class InventoryListsController < Api::V1::ApplicationController
      guard_all!


      def index
        render json: InventoryList.all.to_json
      end

      def inventory_items
        inventory_list = InventoryList.find_by_id(params[:inventory_list_id])
        if inventory_list
          render json: {
                     result: 1,
                     inventory_items: inventory_list.inventory_items
          }
        else
          render json: {
                     result: 0,
                     content: '盘点单没有找到'
                 }
        end
      end

      def generate_file
        inventory_list = InventoryList.find_by_id(params[:id])
        render json: {result: 0, content: '当前无数据'} unless inventory_list

        if file=inventory_list.generate_file(current_user, params[:type].to_i)
          render json: {result: 1, content: request.base_url + file.path.url}
        else
          render json: {result: 0, content: '当前无数据'}
        end
      end

    end
  end
end