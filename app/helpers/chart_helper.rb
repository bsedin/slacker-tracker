module ChartHelper

  def chartize(interval:, grouped_timesheets:)
    { labels: interval.map{|x| l(x, format: :short)},
      datasets:
        grouped_timesheets.map do |key, timesheets|
          { type: 'bar',
            label: key,
            backgroundColor: interval.map { colorize(key) },
            data: pointize(interval: interval, timesheets: timesheets)
          }
        end

    }.to_json
  end

  private

  def pointize(interval:, timesheets:)
    interval.map.with_index do |date, i|
      timesheets.sum do |timesheet|
        (date..(interval[i+1] || Date.today)).include?(timesheet.created_at.to_date) ? timesheet.hours : 0
      end
    end
  end

  def colorize(string)
    "##{Digest::MD5.hexdigest(string)[0..5]}"
  end
end
