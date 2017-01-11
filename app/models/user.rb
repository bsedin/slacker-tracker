class User < ApplicationRecord
  has_many :timesheets
  has_many :cards, through: :timesheets

  validates :email, presence: true
  validates :name, presence: true

  scope :by_tag, -> (tag) { where('? = ANY (tags)', tag) }

  scope :by_favro_ids, -> (favro_ids) {
    q = favro_ids.is_a?(Array) ? 'IN (?)' : '= ?'
    where("service_ids ->> 'favro' #{q}", favro_ids)
  }

  %w(this last).each do |which|
    %w(day week month year).each do |interval|
      define_method :"#{which}_#{interval}_time", -> {
        timesheets.send(:"#{which}_#{interval}_time")
      }
    end
  end

  def tags
    super || []
  end
end
