class DowntimeRecord < ApplicationRecord
  belongs_to :machine
  belongs_to :craft
  belongs_to :downtime_code

  after_create :calc_standard_work_time

  def calc_standard_work_time
    self.update_attributes(standard_work_time: WorkTime.search_work_time(self.machine.machine_type, self.craft, self.pd_laenge)*self.pd_stueck.to_f/3600)
  end


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

  def self.generate_oee_data dimensionality, time_start, time_end, machine, machine_type
    data=[]

    condition=generate_condition time_start, time_end, machine, machine_type

    query=DowntimeRecord.joins(:machine).where(condition)


    if dimensionality=='machine'
      #######################################################################################################################           by machine
      puts query.count
      record_by_machine=query.select("SUM(downtime_records.Pd_std) as total, downtime_records.*").group(:machine_id)
      puts query.count

      #calc
      worktime_except_holiday = Holiday.calc_except_holiday(time_start.to_time.localtime.to_date, time_end.to_time.localtime.to_date)

      record_by_machine.each do |rm|
        record_by_order=query.where(machine_id: rm.machine_id).group(:pd_bemerk, :pd_stueck)
        standard_work_time=0.0
        record_by_order.each do |ro|
          standard_work_time += ro.standard_work_time
        end

        availability = (worktime_except_holiday - rm.total)/worktime_except_holiday
        performance=standard_work_time/(worktime_except_holiday - rm.total)

        data<<{
            machine: rm.machine,
            availability: availability,
            performance: performance
        }
      end
      #############################################################################################################################################
    else
      ###########################################################################################################################        by time
      record_by_time = query.select("SUM(downtime_records.Pd_std) as total, downtime_records.*").group(:pk_datum)

      record_by_time.each do |rt|
        #时间维度--原则上的工作时间
        worktime_except_holiday = 24.0# Holiday.calc_except_holiday(rt.pk_datum.localtime.to_date, rt.pk_datum.localtime.to_date)

        record_by_order=query.where(pk_datum: rt.pk_datum).group(:pd_bemerk, :pd_stueck)
        standard_work_time=0.0
        record_by_order.each do |ro|
          standard_work_time += ro.standard_work_time
        end

        availability = (Machine.count*worktime_except_holiday - rt.total)/(Machine.count*worktime_except_holiday)
        puts standard_work_time
        puts (Machine.count)
        puts (Machine.count*worktime_except_holiday)
        puts rt.total
        performance = standard_work_time/(Machine.count*worktime_except_holiday - rt.total)

        data<<{
            time: rt.pk_datum,
            availability: availability,
            performance: performance
        }
      end
      #############################################################################################################################################
    end

    data
  end

  def self.generate_downtime_data dimensionality, time_start, time_end, machine, machine_type
    data={}
    condition=generate_condition time_start, time_end, machine, machine_type

    if dimensionality=='machine'
      #downtime code by machine
      record_by_downtime = DowntimeRecord.joins(:machine).joins(downtime_code: [:downtime_type])
                               .where(condition)
                               .select("SUM(downtime_records.Pd_std) as total, downtime_records.*, downtime_types.nr as nr")
                               .group("downtime_types.nr, downtime_records.machine_id")
                               .order(machine_id: :desc)

      record_by_downtime.each do |rd|
        if data[rd.machine.nr].blank?
          data[rd.machine.nr] = {}
        end
        data[rd.machine.nr][rd.nr] = rd.total
      end
    else
      #downtime code by time
      record_by_downtime = DowntimeRecord.joins(:machine).joins(downtime_code: [:downtime_type])
                               .where(condition)
                               .select("SUM(downtime_records.Pd_std) as total, downtime_records.*, downtime_types.nr as nr")
                               .group("downtime_types.nr, downtime_records.pk_datum")
                               .order(pk_datum: :asc)

      record_by_downtime.each do |rd|
        if data[rd.pk_datum].blank?
          data[rd.pk_datum] = {}
        end
        data[rd.pk_datum][rd.nr] = rd.total
      end
    end

    p data
  end
end


