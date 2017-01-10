class DashboardController < ApplicationController

  ZOOMS     = %w(day week month year)
  INTERVALS = %w(this last)

  helper_method :zoom, :interval, :users, :cards

  def index
  end

  protected

  def zoom
    ZOOMS.include?(params[:zoom]) ? params[:zoom] : ZOOMS.first
  end

  def interval
    INTERVALS.include?(params[:interval]) ? params[:interval] : INTERVALS.first
  end

  def users
    @users ||= User.by_tag('developer').sort_by do |user|
      user.public_send(:"#{interval}_#{zoom}_time")
    end.reverse
  end

  def cards
    @users ||= Card.all
  end
end
