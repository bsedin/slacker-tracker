class CreateTimesheets < ActiveRecord::Migration[5.0]
  def change
    create_table :timesheets do |t|
      t.references :card, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.integer    :time, null: false, default: 0

      t.timestamps null: false
    end
  end
end
