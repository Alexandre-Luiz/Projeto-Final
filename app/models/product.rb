class Product < ApplicationRecord
  belongs_to :user
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy

  validates :name, :category, :description, :price,
            presence: true

end
