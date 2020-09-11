class Product < ApplicationRecord
  belongs_to :user
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy

  has_one :order, dependent: :destroy
  has_one_attached :image

  enum status: { enabled: 0, disabled: 10, suspended: 20}

  validates :name, :category, :description, :price,
            presence: true

end
