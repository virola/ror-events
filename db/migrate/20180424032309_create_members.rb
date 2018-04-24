class CreateMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :members do |t|
      t.string :username
      t.string :password_digest
      t.text :bio
      t.string :open_id
      t.string :union_id
      t.date :birthday

      t.timestamps
    end
  end
end
