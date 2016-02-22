class CreateEarthquake < ActiveRecord::Migration
  def change
    create_table :earthquakes do |t|
      t.string :earthquake_id
      t.float :magnitude
      t.string :place
      t.float :longitude
      t.float :latitude
      t.float :depth
      t.time :time

      t.timestamps null: false
    end
    
    add_index :earthquakes, :earthquake_id, unique: true
    add_index :earthquakes, :time
  end
end
  