class CapexService

  def self.generate_report_data year
    data = []
    data[0]={key_start: 'BUD'}
    data[1]={key_start: 'FC1'}
    data[2]={key_start: 'FC2'}

    data[3]={key_start: 'PAM Final Approved'}
    data[4]={key_start: 'PAM Approval In Process'}
    data[5]={key_start: 'PAM Not Start To Approve'}

    data[6]={key_start: 'PA Cost'}
    data[7]={key_start: 'PAM Final Approved But Not Spend'}
    data[8]={key_start: 'Total Not Spend'}

    data[9]={key_start: 'PO Send Out Cost'}
    data[10]={key_start: 'PO In Process Cost'}

    data[11]={key_start: 'Fix Asset Completed Cost'}
    data[12]={key_start: 'Fix Asset In Process Cost'}

    data[13]={key_start: 'Booking Cost'}
    data[14]={key_start: 'Not Booking Cost'}
    data[15]={key_start: 'Total Not Booking Cost'}

    BuManger.all.each do |bu|
      data[0][bu.nr] = Capex.where(bu_code: bu.id).map{|capex| capex.sum_budget(0)}.reduce(0){|t,v| t+=v}
      data[1][bu.nr] = Capex.where(bu_code: bu.id).map{|capex| capex.sum_budget(1)}.reduce(0){|t,v| t+=v}
      data[2][bu.nr] = Capex.where(bu_code: bu.id).map{|capex| capex.sum_budget(2)}.reduce(0){|t,v| t+=v}

      data[3][bu.nr] = Capex.where(bu_code: bu.id).map{|capex| capex.sum_pams_column(:approved)}.reduce(0){|t,v| t+=v}
      data[4][bu.nr] = Capex.where(bu_code: bu.id).map{|capex| capex.sum_pams_column(:in_process)}.reduce(0){|t,v| t+=v}
      data[5][bu.nr] = Capex.where(bu_code: bu.id).map{|capex| capex.sum_pams_column(:budget_not_applied)}.reduce(0){|t,v| t+=v}

      data[6][bu.nr] = Capex.where(bu_code: bu.id).map{|capex| capex.sum_pam_items_cloumn(:total_cost)}.reduce(0){|t,v| t+=v}
      data[7][bu.nr] = data[3][bu.nr] - data[6][bu.nr]
      data[8][bu.nr] = data[0][bu.nr] - data[6][bu.nr]

      data[9][bu.nr] = Capex.where(bu_code: bu.id).map{|capex| capex.sum_pam_items_cloumn(:po_cost)}.reduce(0){|t,v| t+=v}
      data[10][bu.nr] = data[6][bu.nr] - data[9][bu.nr]

      data[11][bu.nr] = Capex.where(bu_code: bu.id).map{|capex| capex.sum_pam_items_cloumn(:completed_amount)}.reduce(0){|t,v| t+=v}
      data[12][bu.nr] = data[9][bu.nr] - data[11][bu.nr]

      data[13][bu.nr] = Capex.where(bu_code: bu.id).map{|capex| capex.sum_pam_items_cloumn(:final_cost)}.reduce(0){|t,v| t+=v}
      data[14][bu.nr] = data[11][bu.nr] - data[13][bu.nr]
      data[15][bu.nr] = data[0][bu.nr] - data[13][bu.nr]
    end

    data.each do |d|
      d[:key_end] = d.except(:key_start).values.reduce{|t,v| t+=v}
    end

    data
  end
end