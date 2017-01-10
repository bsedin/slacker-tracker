class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.jsonb  :service_ids

      t.timestamps null: false
    end
    add_index :users, :name
    add_index :users, :email, unique: true
    add_index :users, :service_ids, using: :gin
  end
end
