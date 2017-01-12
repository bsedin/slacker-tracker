module GroupedTimesheets
  extend ActiveSupport::Concern

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

  def timesheets_by_card
    timesheets.group_by do |ts|
      ts.card.title
    end
  end

  included do
    helper_method  :timesheets_by_user, :timesheets_by_customer, :timesheets_by_card
  end
end
