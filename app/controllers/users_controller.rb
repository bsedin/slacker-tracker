class UsersController < ApplicationController
  include Filterable
  include GroupedTimesheets

  helper_method :user, :timesheets

  helper ChartHelper

  def show
  end

  protected

  def user
    @user ||= User.find(params[:id])
  end

  def timesheets
    @timesheets ||= user.timesheets.within(start_date..end_date)
  end
end
