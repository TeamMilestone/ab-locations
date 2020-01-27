class CreateSnapshotedRooms < ActiveRecord::Migration[6.0]
  def change
    create_table :snapshoted_rooms do |t|
      t.bigint :ab_room_id
      t.bigint :ab_user_id
      t.string :name
      t.integer :beds
      t.integer :bedrooms
      t.integer :bathrooms
      t.string :superhost
      t.string :localized_city
      t.decimal :star_rating
      t.integer :review_count
      t.json :snapshot_data

      t.timestamps
    end
  end
end
