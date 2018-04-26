class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.belongs_to :member, index: true
      t.string :name
      t.text :description
      t.boolean :is_public
      t.date :date

      t.timestamps
    end
    # add_index :events, :member_id
  end
end
