class Order < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :payment_method,
             presence: true
  validates :discount, 
             numericality: { greater_than_or_equal_to: 0 }
  validate :discount_vs_price

  enum status: { in_progress: 0, completed: 10, canceled: 20 }

  def price_calculation
    product_price - discount
  end

  def discount_vs_price
    if discount >= product.price
      errors.add(:discount, 'Desconto não pode ser maior que o preço do produto')
    end
  end
end
