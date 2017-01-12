module Filterable
  extend ActiveSupport::Concern

  ZOOMS = %w(day week month year)

  included do
    helper_method :start_date, :end_date, :interval, :zoom, :filter_params
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
    while date <= end_date.send(:"end_of_#{zoom}").to_date
      output << date.send(:"beginning_of_#{zoom}").to_date
      date += 1.send(zoom)
    end
    output
  end

  def zoom
    ZOOMS.include?(params[:zoom]) ? params[:zoom] : ZOOMS.first
  end

  def filter_params
    params.permit(:start_date, :end_date, :zoom, :interval).to_h
  end
end
