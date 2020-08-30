class Product < ApplicationRecord
  belongs_to :user

  validates :name, :category, :description, :price,
            presence: true

end
