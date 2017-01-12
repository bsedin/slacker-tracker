class Timesheet < ApplicationRecord
  belongs_to :card
  belongs_to :user

  scope :within, -> (interval) {
    where(created_at: interval.first.to_time.beginning_of_day..interval.last.to_time.end_of_day)
  }

  %w(this last).each do |which|
    %w(day week month year).each do |interval|
      scope :"#{which}_#{interval}", -> {
        offset     = which == 'last' ? 1.send(interval) : 0
        start_date = Time.current.send("beginning_of_#{interval}") - offset
        end_date   = Time.current.send("end_of_#{interval}") - offset
        within(start_date..end_date)
      }

      scope :"#{which}_#{interval}_time", -> {
        send(:"#{which}_#{interval}").sum(:time)
      }
    end
  end

  def hours
    (time / 3600.0).round(1)
  end
end
