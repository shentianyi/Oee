module Api
  module V1
    class InventoryListsController < Api::V1::ApplicationController
      # guard_all!


      def index
        # render json: InventoryList.all.to_json
        data =[]
        InventoryList.all.each do |i|
          data<<{id: i.id.to_s, name: i.name}
        end

        render json: data.to_json
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
        user = User.find_by_id(params[:user_id])
        return render json: {result: 0, content: '用户没有找到，请重新登陆'} if user.blank?

        inventory_list = InventoryList.find_by_id(params[:id])
        return render json: {result: 0, content: '当前无数据'} if inventory_list.blank?

        if file=inventory_list.generate_download_file(user, params[:type].to_i)
          render json: {result: 1, content: request.base_url + file.path.url}
        else
          render json: {result: 0, content: '当前无数据'}
        end
      end

      def generate_upload_file
        # puts '------------------------'
        # p JSON.parse(params.to_s)
        # p JSON.parse(params.to_h)
        # p JSON.parse(params.to_json)
        # puts '------------------------'
        # p params.to_json
        # puts params[:inventory_list_id]
        # puts '--------------------------'

        # parse_params = JSON.parse(params)

        user = User.find_by_id(params[:user_id])
        return render json: {result: 0, content: '用户没有找到，请重新登陆'} if user.blank?

        unless list = InventoryList.find_by_id(params[:inventory_list_id])
          return render json: {result: 0, content: "盘点单#{params[:inventory_list_id]}不存在"}
        end

        unless [FileUploadType::OVERALL, FileUploadType::RECOVERY].include?(params[:type].to_i)
          return render json: {result: 0, content: "盘点类型#{params[:type]}不正确"}
        end

        if params[:data].length<1
          return render json: {result: 0, content: "数据为空"}
        end

        # user = User.find_by_email "admin@ts.com"
        if UserInventoryTaskService.create params, user, list
          render json: {result: 1, content: '数据上传成功'}
        else
          render json: {result: 0, content: '数据上传失败'}
        end
      end

    end
  end
end