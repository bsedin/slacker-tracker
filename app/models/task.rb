class Task < ApplicationRecord
  has_many :timesheets
  has_many :users, through: :timesheets
end
