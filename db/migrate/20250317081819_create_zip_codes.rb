class CreateZipCodes < ActiveRecord::Migration[8.0]
  def change
    create_table :zip_codes do |t|
      t.string :code, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
