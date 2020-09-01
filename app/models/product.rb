class Product < ApplicationRecord
  belongs_to :user
  has_many :questions
  has_many :answers

  validates :name, :category, :description, :price,
            presence: true

end
