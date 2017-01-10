class Card < ApplicationRecord
  has_many :timesheets
  has_many :users, through: :timesheets

  scope :active,   -> { where(archived: false) }
  scope :archived, -> { where(archived: true) }
  scope :by_tag,   -> (tag) { where('? = ANY (tags)', tag) }

  def estimate
    nil
  end

  def spent
    timesheets.sum(:time)
  end

  def underestimated?
    estimated ? spent > estimated : false
  end

  def members
    User.where(id: member_ids)
  end
end
