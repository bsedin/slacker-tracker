class CreateCards < ActiveRecord::Migration[5.0]
  def change
    create_table :cards do |t|
      t.string  :title
      t.jsonb   :service_ids
      t.jsonb   :data
      t.integer :member_ids, array: true
      t.boolean :archived, null: false, default: false
      t.text    :description

      t.timestamps null: false
    end
    add_index :cards, :service_ids, using: :gin
    add_index :cards, :member_ids,  using: :gin
  end
end
