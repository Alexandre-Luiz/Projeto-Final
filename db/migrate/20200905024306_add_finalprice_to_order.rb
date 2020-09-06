class AddFinalpriceToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :final_price, :decimal
  end
end
