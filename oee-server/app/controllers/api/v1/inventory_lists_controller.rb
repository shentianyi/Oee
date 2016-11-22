module Api
  module V1
    class InventoryListsController < Api::V1::ApplicationController
      # guard_all!


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

      def generate_download_file
        inventory_list = InventoryList.find_by_id(params[:id])
        render json: {result: 0, content: '当前无数据'} unless inventory_list

        if file=inventory_list.generate_download_file(current_user, params[:type].to_i)
          render json: {result: 1, content: request.base_url + file.path.url}
        else
          render json: {result: 0, content: '当前无数据'}
        end
      end

      def generate_upload_file
        puts '------------------------'
        p JSON.parse(params.to_s)
        p JSON.parse(params.to_h)
        p JSON.parse(params.to_json)
        puts '------------------------'
        p params.to_json
        puts params[:inventory_list_id]
        puts '--------------------------'
        unless list = InventoryList.find_by_id(params[:inventory_list_id])
          return render json: {result: 0, content: "盘点单#{params[:inventory_list_id]}不存在"}
        end

        unless [FileUploadType::OVERALL, FileUploadType::RECOVERY].include?(params[:type].to_i)
          return render json: {result: 0, content: "盘点类型#{params[:type]}不正确"}
        end

        if params[:data].length<1
          return render json: {result: 0, content: "数据为空"}
        end

        current_user = User.find_by_email "admin@ts.com"
        if UserInventoryTaskService.create params, current_user, list
          render json: {result: 1, content: '数据上传成功'}
        else
          render json: {result: 0, content: '数据上传失败'}
        end
      end

    end
  end
end