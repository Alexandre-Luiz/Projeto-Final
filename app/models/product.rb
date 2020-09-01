class Product < ApplicationRecord
  belongs_to :user
  has_many :questions

  validates :name, :category, :description, :price,
            presence: true

end
