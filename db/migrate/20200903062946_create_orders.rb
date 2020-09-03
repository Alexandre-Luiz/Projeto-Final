class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.decimal :discount
      t.string :payment_method
      t.string :address
      t.string :comment

      t.timestamps
    end
  end
end
