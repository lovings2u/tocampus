class CreateStations < ActiveRecord::Migration
  def change
    create_table :stations do |t|
      t.string :gpsX, null: false
      t.string :stationNm, null: false
      t.string :gpsY, null: false
      t.string :stationId, null: false
      t.string :arsId, null: false
      t.references :univ, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
