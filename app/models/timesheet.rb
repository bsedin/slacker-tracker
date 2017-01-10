class Timesheet < ApplicationRecord
  belongs_to :card
  belongs_to :user

  scope :within, -> (interval) { where(created_at: interval) }

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
end
