module Api
  module V1
    class UsersController < Api::V1::ApplicationController
      # before_action :doorkeeper_authorize!

      def index
        render json: '11111111'
      end

      def login
        p params

        # login_info=JSON.parse(params)
        login_info=params#["user"]

        if (user=User.find_for_database_authentication(name: login_info["name"].to_s)) && user.valid_password?(login_info["password"].to_s)
          render json: {
                     result: true,
                     content: '登陆成功',
                     data: {id: user.id,
                            email: user.email,
                            name: user.name,
                            token: user.access_token.token
                     }
                 }
        else
          render json: {
                     result: false,
                     content: '用户名或密码不正确'
                 }
        end
      end

      def logout
        render json: {
                   result: true,
                   content: '登出成功'
               }
      end


    end
  end
end