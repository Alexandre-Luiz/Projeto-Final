class Order < ApplicationRecord
  belongs_to :user
  belongs_to :product

  def price_calculation
    product_price - discount
  end
end
