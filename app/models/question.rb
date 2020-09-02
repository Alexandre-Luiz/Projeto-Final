class Question < ApplicationRecord
  belongs_to :user
  belongs_to :product
  has_one :answer, dependent: :destroy
end
