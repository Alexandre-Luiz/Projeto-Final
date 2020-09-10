class ChangeDiscountInOrder < ActiveRecord::Migration[6.0]
  def up
    change_column :orders, :discount, :decimal, default: 0.0
  end

  def down
    change_column :orders, :discount, :decimal, default: nil
  end
end
