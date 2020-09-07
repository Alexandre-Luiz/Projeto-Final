class Order < ApplicationRecord
  belongs_to :user
  belongs_to :product

  enum status: { in_progress: 0, completed: 10, canceled: 20 } 

  def price_calculation
    product_price - discount
  end
end
