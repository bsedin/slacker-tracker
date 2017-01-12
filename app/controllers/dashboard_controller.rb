class DashboardController < ApplicationController
  include Filterable
  include GroupedTimesheets

  helper_method :users, :cards

  helper ChartHelper

  def index
  end

  protected

  def users
    @users ||= User.by_tag('developer').order(name: :asc)
  end

  def timesheets
    @timesheets ||= Timesheet.within(start_date..end_date)
  end

  def cards
    @users ||= Card.all
  end
end
