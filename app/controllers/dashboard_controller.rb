class DashboardController < ApplicationController

  helper ChartHelper

  ZOOMS = %w(day week month year)

  helper_method :zoom, :users, :cards, :start_date, :end_date, :interval,
    :timesheets_by_user, :timesheets_by_customer

  def index
  end

  protected

  def start_date
    @start_date ||= params[:start_date] ? Date.parse(params[:start_date]) : Time.current.beginning_of_week.to_date
  end

  def end_date
    @end_date ||= params[:end_date] ? Date.parse(params[:end_date]) : Time.current.to_date
  end

  def interval
    output = []
    date = start_date
    while date < end_date
      output << date.send(:"beginning_of_#{zoom}").to_date
      date += 1.send(zoom)
    end
    output
  end

  def zoom
    ZOOMS.include?(params[:zoom]) ? params[:zoom] : ZOOMS.first
  end

  def users
    @users ||= User.by_tag('developer').order(name: :asc)
  end

  def timesheets
    @timesheets ||= Timesheet.within(start_date..end_date)
  end

  def timesheets_by_user
    timesheets.group_by do |ts|
      ts.user.name
    end
  end

  def timesheets_by_customer
    timesheets.group_by do |ts|
      ts.card.tags.first || 'none'
    end
  end

  def cards
    @users ||= Card.all
  end
end
