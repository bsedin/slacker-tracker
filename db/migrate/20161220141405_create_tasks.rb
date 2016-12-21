class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.string :service_name
      t.string :service_id
      t.json   :data
    end
    add_index :tasks, [:service_name, :service_id], unique: true
  end
end
