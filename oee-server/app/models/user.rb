class User < ApplicationRecord
  extend Devise::Models


  validates_presence_of :name, :message => "请输入完整的用户信息!"
  validates_presence_of :email, :message => "请输入完整的用户信息!"
  validates_presence_of :password, :message => "请输入完整的用户信息!"
  validates_uniqueness_of :email, :message => "邮箱已被注册!"


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  def method_missing(method_name, *args, &block)
    if Role::RoleMethods.include?(method_name)
      Role.send(method_name, self.role)
    elsif method_name.match(/permission?/)
      if self.admin?
        true
      else
        if self.permissions.where(name: args[0].to_s).blank?
          false
        else
          true
        end
      end
    else
      super
    end
  end
end
