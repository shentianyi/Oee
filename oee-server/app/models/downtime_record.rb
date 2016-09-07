class DowntimeRecord < ApplicationRecord
  belongs_to :machine
  belongs_to :craft
  belongs_to :downtime_code


  def self.generate_condition time_start, time_end, machine, machine_type
    condition = {}

    if machine
      condition["downtime_records.machine_id"] = machine.id
    end

    if machine_type
      condition["machines.machine_type_id"] = machine_type.id
    end

    #入账日期
    condition["downtime_records.pk_datum"] = Time.parse(time_start).utc.to_s...Time.parse(time_end).utc.to_s
    condition
  end

  def self.generate_oee_data time_start, time_end, machine, machine_type
    condition=generate_condition time_start, time_end, machine, machine_type

    query=DowntimeRecord.joins(:machine).where(condition)

    puts query.count
    record_by_machine=query.select("SUM(downtime_records.Pd_std) as total, downtime_records.*")
                          .group(:machine_id)

    puts query.count


    data=[]
    record_by_machine.each do |rm|
      record_by_order=query.where(machine_id: rm.machine_id).group(:pd_bemerk)
      naturl_work_time=0.0
      record_by_order.each do |ro|
        naturl_work_time += (WorkTime.search_work_time(ro.machine.machine_type, ro.craft, ro.pd_laenge)*ro.pd_stueck.to_f/3600)
      end

      availability = (((time_end.to_time-time_start.to_time)/3600.0) - rm.total)/((time_end.to_time-time_start.to_time)/3600.0)
      performance=naturl_work_time/(((time_end.to_time-time_start.to_time)/3600.0) - rm.total)

      data<<{
          machine: rm.machine,
          availability: availability,
          performance: performance
      }
    end

    data
  end
end


