class AddTagsToUsersAndCards < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :tags, :string, array: true
    add_index  :users, :tags, using: :gin

    add_column :cards, :tags, :string, array: true
    add_index  :cards, :tags, using: :gin
  end
end
