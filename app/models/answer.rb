class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question
  belongs_to :product

  validates :content, presence: true
end
