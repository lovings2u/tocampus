class CreateUnivs < ActiveRecord::Migration
  def change
    create_table :univs do |t|
      t.string :name
      t.date :fest_s
      t.date :fest_e
      t.string :lineup
      t.string :gpsX
      t.string :gpsY
      t.string :radius
      t.string :univ_mark

      t.timestamps null: false
    end
  end
end
