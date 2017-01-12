module ChartHelper

  def chartize(interval:, grouped_timesheets:, zoom: nil)
    { labels: labelize_interval(interval: interval, zoom: zoom),
      datasets:
        grouped_timesheets.map do |title, timesheets|
          { type: 'bar',
            label: title,
            backgroundColor: interval.map { colorize(title) },
            data: pointize_interval(interval: interval, timesheets: timesheets, zoom: zoom)
          }
        end
    }.to_json
  end

  private

  def pointize_interval(interval:, timesheets:, zoom: nil)
    interval.map.with_index do |date, i|
      current_interval =
        if date == interval.last
          zoom ? date..date.send(:"end_of_#{zoom}") : date..date
        else
          date..(interval[i+1]-1)
        end
      timesheets.sum do |timesheet|
        timesheet_date = timesheet.created_at.to_date
        current_interval.include?(timesheet_date) ? timesheet.hours : 0
      end
    end
  end

  def labelize_interval(interval:, zoom: nil)
    case zoom
    when 'month'
      interval.map{|date| l(date, format: '%b %Y')}
    when 'week'
      interval.map do |date|
        last_day = date.end_of_week
        "#{l(date, format: '%d %b')} - #{l(last_day, format: '%d %b')}"
      end
    when 'year'
      interval.map{|date| date.year}
    else
      interval.map{|date| l(date, format: '%a, %d %b')}
    end
  end

  def colorize(string)
    "##{Digest::MD5.hexdigest(string)[0..5]}"
  end
end
