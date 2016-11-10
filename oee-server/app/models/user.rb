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

  after_create :generate_access_token
  has_many :access_tokens, class_name: 'Doorkeeper::AccessToken', foreign_key: :resource_owner_id
  has_many :user_area_items, dependent: :destroy
  has_many :user_inventory_tasks, dependent: :destroy

  # the last access token for user
  def access_token
    access_tokens.where(application_id: Settings.default_app.id,
                        revoked_at: nil).where('date_add(created_at,interval expires_in second) > ?', Time.now.utc).
        order('created_at desc').
        limit(1).
        first || generate_access_token
  end

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

  def generate_access_token
    if Settings.default_app
      Doorkeeper::AccessToken.create!(application_id: Settings.default_app.id,
                                      resource_owner_id: self.id,
                                      expires_in: Doorkeeper.configuration.access_token_expires_in)
    end
  end
end
