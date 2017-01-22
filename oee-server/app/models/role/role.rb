#encoding: utf-8
require 'base_class'
class Role
  RoleMethods=[:admin?, :user?, :manager?, :equipment_manager?, :capex_manager?, :purchase_manager?, :finance_manager?, :assistant?, :planning_charge?, :ts_charge?, :planning_engineer?, :ts_engineer?, :technician?]
  @@roles={
      :'100' => {:name => 'admin', :display => (I18n.t 'manage.user.role.admin')},
      :'200' => {:name => 'manager', :display => (I18n.t 'manage.user.role.manager')},
      :'300' => {:name => 'equipment_manager', :display => (I18n.t 'manage.user.role.equipment_manager')},
      :'400' => {:name => 'purchase_manager', :display => (I18n.t 'manage.user.role.purchase_manager')},
      :'500' => {:name => 'finance_manager', :display => (I18n.t 'manage.user.role.finance_manager')},
      :'600' => {:name => 'assistant', :display => (I18n.t 'manage.user.role.assistant')},
      :'700' => {:name => 'planning_charge', :display => (I18n.t 'manage.user.role.planning_charge')},
      :'800' => {:name => 'ts_charge', :display => (I18n.t 'manage.user.role.ts_charge')},
      :'900' => {:name => 'planning_engineer', :display => (I18n.t 'manage.user.role.planning_engineer')},
      :'1000' => {:name => 'ts_engineer', :display => (I18n.t 'manage.user.role.ts_engineer')},
      :'1100' => {:name => 'technician', :display => (I18n.t 'manage.user.role.technician')},
      :'1200' => {:name => 'user', :display => (I18n.t 'manage.user.role.user')},
      :'1300' => {:name => 'capex_manager', :display => (I18n.t 'manage.user.role.capex_manager')}
  }

  class<<self
    RoleMethods.each do |m|
      define_method(m) { |id|
        @@roles[id_sym(id)][:name]==m.to_s.sub(/\?/, '')
      }
    end
    @@roles.each do |key,value|
      define_method(value[:name]){
        key.to_s.to_i
      }
    end
  end

  def self.display id
    I18n.t 'manage.user.role.'+@@roles[id_sym(id)][:name]
  end

  def self.id_sym id
    id.to_s.to_sym
  end

  def self.role_items
    role_items=[]
    @@roles.each do |key, value|
      role_items<<RoleItem.new(id: key.to_s.to_i, name: Role.display(key))
    end
    return role_items
  end


  def self.menu
    roles = []
    @@roles.each { |key, value|
      roles <<[value[:display], key.to_s]
    }
    roles
  end
end

class RoleItem<CZ::BaseClass
  attr_accessor :id, :name
end