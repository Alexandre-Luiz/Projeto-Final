class Product < ApplicationRecord
  belongs_to :user
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_one :order, dependent: :destroy

  enum status: { enabled: 0, disabled: 10}

  validates :name, :category, :description, :price,
            presence: true


end
