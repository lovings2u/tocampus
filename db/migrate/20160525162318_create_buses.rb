class CreateBuses < ActiveRecord::Migration
  def change
    create_table :buses do |t|
      t.string :busRouteId, null: false
      t.string :busRouteNm, null: false

      t.timestamps null: false
    end
  end
end
