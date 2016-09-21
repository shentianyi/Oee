DowntimeRecord.transaction do

  DowntimeRecord.all.each do |r|
    r.update_attributes(monthly: r.pk_datum.localtime.strftime('%Y%m').to_i)
  end

end