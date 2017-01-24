class PamItem < ApplicationRecord
  belongs_to :pam_list

  after_update :sync_asset_tracks


  def sync_asset_tracks
    PamItem.transaction do
      if self.asset_nrs_changed? && self.asset_status!=AssetTrackSyncStatus::DONE
        params={}
        params[:qty] = 1
        params[:completed_id] = self.completed_id

        self.asset_nrs.split(';').each do |nrs|
          if nrs.include?('-')
            data=nrs.split('-')
            if data.count!=2
              self.update_attributes({
                                         remark: "格式错误,例:'1;3-5;7-9'"
                                     })
            else
              data[0].to_i.upto(data[1].to_i) do |nr|
                params[:nr] = nr
                params[:apply_id] = self.pa_no
                if fat=FixAssetTrack.where(nr: nr, ancestry: nil).first
                  params[:equip_create_way] = EquipmentAddEnum::ADD_EQUIPMENT
                  params[:ancestry] = fat.id
                else
                  params[:equip_create_way] = EquipmentAddEnum::CREATE_EQUIPMENT
                end
                #TODO--一资产多设备

                fa = FixAssetTrack.new(params)
                unless fa.save
                  raise fa.errors.to_json
                end
              end
            end
          else
            params[:nr] = self.asset_nrs
            params[:apply_id] = self.pa_no
            if fat=FixAssetTrack.where(nr: self.asset_nrs, ancestry: nil).first
              params[:equip_create_way] = EquipmentAddEnum::ADD_EQUIPMENT
              params[:ancestry] = fat.id
            else
              params[:equip_create_way] = EquipmentAddEnum::CREATE_EQUIPMENT
            end
            #TODO--一资产多设备

            fa = FixAssetTrack.new(params)
            unless fa.save
              raise fa.errors.to_json
            end
          end
        end

        self.update_attributes({asset_status: AssetTrackSyncStatus::DONE})
      end
    end

  end

end
