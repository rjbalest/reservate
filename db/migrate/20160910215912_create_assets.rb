class CreateAssets < ActiveRecord::Migration[5.0]
  def change
    create_table :assets do |t|
      t.string :ip_address
      t.string :label
      t.text :description

      t.timestamps
    end
  end
end
